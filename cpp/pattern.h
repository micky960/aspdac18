#include<iostream>
#include<string>
#include<vector>
#include<boost/algorithm/string.hpp>

#include "constants.h"

class pattern{
        public:std::string ipPatt, opPatt;
                std::vector<int> iIndex, oIndex;
                int sec;

                pattern(std::string line);
                int getSec(){return sec;}
                int  getCompCost(){return iIndex.size()*COMP_N;}
                bool findOpIndex(int i);
        private:
		void _getIndex(std::string p, std::vector<int>& indexList);
};

class faultRes{
        public:
        int opIndex;
        std::vector<std::pair<int, char> > ipPattIndex;  //stores for which ip patterns it fails; and the correct CUT response
        faultRes(int op, std::vector<std::pair<int, char> > list);
};

