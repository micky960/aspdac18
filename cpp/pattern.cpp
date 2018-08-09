#include<iostream>
#include<string>
#include<vector>
#include<sstream>
#include<boost/algorithm/string.hpp>

#include "pattern.h"

pattern::pattern(std::string line){
     std::vector<std::string> word;
     boost::split(word, line, boost::is_any_of(":"));
     std::stringstream ss(word[1]);
     ss >> ipPatt;
     ss >> opPatt;
     boost::algorithm::trim(ipPatt);
     boost::algorithm::trim(opPatt);
     _getIndex(ipPatt, iIndex);
     _getIndex(opPatt, oIndex);

	sec = iIndex.size();
}

bool pattern::findOpIndex(int i){
	if(std::find(oIndex.begin(), oIndex.end(), i) != oIndex.end()) return true;
	else return false;
}

void pattern::_getIndex(std::string p, std::vector<int>& indexList){
	for(int i=0; i<p.size(); i++){
		if(p[i]!='x')
			indexList.push_back(i);
	}
}

faultRes::faultRes(int op, std::vector<std::pair <int, char> > list){
	opIndex = op;
	ipPattIndex = list;
}

