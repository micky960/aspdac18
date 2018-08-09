#include<iostream>
#include<fstream>
#include<cstdlib>
#include<string>
#include<sstream>
#include<vector>
#include<utility>
#include <unordered_map>
#include<algorithm>
#include<stdlib.h>
#include<cassert>
#include<math.h>
#include <sys/types.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <boost/algorithm/string.hpp>
#include <boost/tokenizer.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/unordered_map.hpp>
#include <sstream>

#include "constants.h"
#include "pattern.h"

class fault_c{
        public:

        std::vector<pattern*> pList;
        std::vector<faultRes*> fResList;
        std::vector<std::string> ipList, opList;
        std::string node;
        int sec, minSecIndex, costOnePatt, numValidKey;

	fault_c(std::string n, std::ifstream& flt);
	int getSec(){return sec;}
	int getNumValidKey(){return numValidKey;}
	int getLeastSec(){return pList[minSecIndex]->getSec();}
        int getNumPatt(){return pList.size();}
        bool checkEqv(std::string name);
        void synthFICkt(std::string name);
        double getOnePattCost(){return costOnePatt;}//cost to correct the one pattern without FI ckt
        void recoverCkt(std::string path);
        void recoverOnePattCkt(std::string path);
        void doEco(std::string name);
        void checkKeyConstraint(std::string name);

	private:
		void _compSec();
		void _getLeastSec();
		void _compOpFailList();
		double _getFICost(std::string name);
		bool _checkEqKey(std::string name);

};


