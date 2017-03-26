#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <utility>
#include <vector>
#include <cmath>
#include <map>
#include <set>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0

uint numVars;
uint numClauses;
vector<vector<int> > clauses;
vector<int> model;
vector<int> modelStack;
uint indexOfNextLitToPropagate;
uint decisionLevel;


struct literal {
  int l;
  vector<uint> positiveClauses;
  vector<uint> negativeClauses;
};

vector<literal> occurenceVec;
vector< pair<float,uint> > decisionList;
vector<uint> conflicts;
map<uint,vector<uint> > occurenceList;

uint decisions = 0;
uint propagations = 0;

bool cmp(pair<float,uint> a, pair<float,uint> b){
  return a.first>b.first;
}


void readClauses( ){
  // Skip comments
  char c = cin.get();
  while (c == 'c') {
    while (c != '\n') c = cin.get();
    c = cin.get();
  }  
  // Read "cnf numVars numClauses"
  string aux;
  cin >> aux >> numVars >> numClauses;
  clauses.resize(numClauses);  
  conflicts.resize(numVars+1,0);
  occurenceVec.resize(numVars+1);
  // Read clauses
  for (uint i = 0; i < numClauses; ++i) {
    int lit;
    while (cin >> lit and lit != 0) {
      clauses[i].push_back(lit);
      occurenceVec[abs(lit)].l = abs(lit);
      if (lit>0) {
          occurenceVec[lit].positiveClauses.push_back(i);
      }
      else occurenceVec[abs(lit)].negativeClauses.push_back(i);
      if (occurenceList.find(abs(lit)) != occurenceList.end()) occurenceList[abs(lit)].push_back(i);
      else {
        occurenceList[abs(lit)].push_back(i);
      }
    }
  }    
}


int currentValueInModel(int lit){
  if (lit >= 0) return model[lit];
  else {
    if (model[-lit] == UNDEF) return UNDEF;
    else return 1 - model[-lit];
  }
}


void setLiteralToTrue(int lit){
  modelStack.push_back(lit);
  if (lit > 0) model[lit] = TRUE;
  else model[-lit] = FALSE;	
}


bool propagateGivesConflict ( ) {
  while ( indexOfNextLitToPropagate < modelStack.size() ) {
    ++propagations;

    ++indexOfNextLitToPropagate;
    int slit = modelStack[indexOfNextLitToPropagate-1];
    uint lit = abs(modelStack[indexOfNextLitToPropagate-1]);
    int val = model[lit];
    vector<uint>* clauses2check = val == TRUE ? &occurenceVec[slit].negativeClauses : &occurenceVec[-slit].positiveClauses;
    uint size = val == TRUE ? occurenceVec[slit].negativeClauses.size() : occurenceVec[-slit].positiveClauses.size();
    for (uint i = 0; i < size; ++i) {
      bool someLitTrue = false;
      uint numUndefs = 0;
      int lastLitUndef = 0;
      uint nclause = (*clauses2check)[i];        
      uint size2 = clauses[nclause].size();
      for (uint k = 0; not someLitTrue and k < size2; ++k){
        int _lit = clauses[nclause][k];
        int val = currentValueInModel(_lit);
        if (val == TRUE) someLitTrue = true;
        else if (val == UNDEF){ ++numUndefs; lastLitUndef = _lit; }
      }
      
    
      if (not someLitTrue and numUndefs == 0) {
        
        if (slit < 0) ++conflicts[lit];
        else for (uint t = 0; t < size2; ++t)  ++conflicts[abs(clauses[nclause][t])];
        return true; // conflict! all lits false
      }
      else if (not someLitTrue and numUndefs == 1) { setLiteralToTrue(lastLitUndef);  }
    }    
  }
  return false;
}


void backtrack(){
  uint i = modelStack.size() -1;
  int lit = 0;
  while (modelStack[i] != 0){ // 0 is the DL mark
    lit = modelStack[i];
    model[abs(lit)] = UNDEF;
    modelStack.pop_back();
    --i;
  }  
  // at this point, lit is the last decision
  modelStack.pop_back(); // remove the DL mark
  --decisionLevel;
  indexOfNextLitToPropagate = modelStack.size();
  setLiteralToTrue(-lit);  // reverse last decision

}

// Calculo de valores heuristicos para cada uno de los literales (heuristica estatica Jeroslow-Wang)
float j(uint l) {
  float res = 0;
  uint n = occurenceList[l].size();
  uint nClause,size;
  int exp;
  for (uint i = 0; i < n; ++i) {
    nClause = occurenceList[l][i];
    size = clauses[nClause].size();
    exp = -size;
    //cout << exp << " " << pow(2,exp) << " ";
    //cout << endl;
    res += float(pow(2,exp));
  }
  //cout << res << endl;
  return res;
}

// Heuristic for finding the next decision literal:
int getNextDecisionLiteral(){
    ++decisions;

    uint decidedLit = 0;

    //Cogemos el primer literal UNDEF con valor heuristico segun Jeroslow-Wang heuristic
    for (uint i = 0; i< numVars; ++i) {
      uint lit = decisionList[i].second;
      if(lit != 0 and model[lit] == UNDEF) {decidedLit = lit; break;}
    }

    // Miramos si hay algun literal con mas conflictos que el elegido (heuristica dinamica)
    bool divide = false;
    for(uint i = 0; i < numVars; ++i) {
      if (conflicts[decisionList[i].second] > numClauses) divide = true;
      else if(decisionList[i].second!= 0 and model[decisionList[i].second] == UNDEF and conflicts[decisionList[i].second]>conflicts[decidedLit]) decidedLit = decisionList[i].second;
    }
    //Reducimos el numero de conflictos si se da el caso de que algun literal tenga mas conflictos que numero de clausulas hay.
    if (divide) for(uint i = 0; i<=numVars;++i) conflicts[i]/=2;
    return decidedLit;
}

void checkmodel(){
  for (int i = 0; i < numClauses; ++i){
    bool someTrue = false;
    for (int j = 0; not someTrue and j < clauses[i].size(); ++j)
      someTrue = (currentValueInModel(clauses[i][j]) == TRUE);
    if (not someTrue) {
      cout << "Error in model, clause num " << i <<" is not satisfied:";
      for (int j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " " << currentValueInModel(clauses[i][j]) << " ";
      cout << endl;
      exit(1);
    }
  }  
}

int main(){ 
  readClauses(); // reads numVars, numClauses and clauses
  model.resize(numVars+1,UNDEF);
  indexOfNextLitToPropagate = 0;  
  decisionLevel = 0;

  // Càlculo heuristica estatica (Jeroslow-Wang) para cada literal
  for (uint i = 1; i <= numVars; ++i) {
    pair<float,uint> p(j(i),i);
    //cout << "pair: " << p.first << " " << p.second << " ";
    decisionList.push_back(p);
  }
  sort(decisionList.begin(),decisionList.end(),cmp);

  // Eliminamos esta estructura para evitar cache misses (da mejores tiempos)
  //occurenceList.clear();

  // Miramos si hay literales que en las clausulas donde estan aparezcan unicamente sin negar o unicamente negados y les 
  // asignamos el valor que satisfazca todas las clausulas donde aparece.
   for(uint i = 1; i < occurenceVec.size(); ++i) {
        if(occurenceVec[i].l!=0 and occurenceVec[i].negativeClauses.size() == 0) {setLiteralToTrue(i); }
        else if (occurenceVec[i].l!=0 and occurenceVec[i].positiveClauses.size() == 0) {setLiteralToTrue(-i);}
    }

  
  // Take care of initial unit clauses, if any
  for (uint i = 0; i < numClauses; ++i)
    if (clauses[i].size() == 1) {
      int lit = clauses[i][0];
      int val = currentValueInModel(lit);
      if (val == FALSE) {cout << "UNSATISFIABLE" << endl; return 10;}
      else if (val == UNDEF) setLiteralToTrue(lit);
    }
  
  // DPLL algorithm
  while (true) {
    while ( propagateGivesConflict() ) {
      if ( decisionLevel == 0) { cout << "UNSATISFIABLE\n"<<"Decisions: "<<decisions<<"\nPropagations: "<<" "<<propagations<< endl; return 10; }
      backtrack();
    }
    

    int decisionLit = getNextDecisionLiteral();
    if (decisionLit == 0) { checkmodel(); cout << "SATISFIABLE\n"<<"Decisions: "<< decisions<<"\nPropagations: "<<propagations << endl; return 20; }
    // start new decision level:
    modelStack.push_back(0);  // push mark indicating new DL
    ++indexOfNextLitToPropagate;
    ++decisionLevel; 
    setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark
  }
}  
