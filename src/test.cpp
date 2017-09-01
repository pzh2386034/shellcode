#include <boost/archive/xml_oarchive.hpp>
#include <boost/archive/xml_iarchive.hpp>
#include <boost/serialization/map.hpp>
#include <fstream>
#include <iostream>
#include <string>
#include "utility.h"

using namespace std;
class italian_sandwich
{
public:
  italian_sandwich(){};
  // 构造函数
  italian_sandwich(const string& bread, const string& cheese, const bool spicy_eggplant_p):m_bread(bread), m_cheese(cheese), m_spicy_eggplant_p(spicy_eggplant_p){}

  void Save(const string & filename)
  {
    ofstream ofs(filename.c_str());
    assert(ofs.good());
    cout<<"OK"<<endl;
    boost::archive::xml_oarchive oa(ofs);
    oa<<boost::serialization::make_nvp("Italianj", this);
  }
  void Load(italian_sandwich &obj,string &filename)
  {
    // 打开文件
    ifstream ifs("temp.xml");
    assert(ifs.good());
    boost::archive::xml_iarchive ia(ifs);
    ia>>BOOST_SERIALIZATION_NVP(obj);
  }
private:
  string m_bread, m_cheese;
  bool m_spicy_eggplant_p;
  friend class boost::serialization::access;
  template<class archive>
  void serialize(archive& ar, const unsigned int version)
  {
    using boost::serialization::make_nvp;
    ar & make_nvp("Bread_pan", m_bread);
    ar & make_nvp("Cheese_pan", m_cheese);
    ar & make_nvp("Add_Spicy_Eggplant", m_spicy_eggplant_p);
  }
};
void save_sandwich(const italian_sandwich & sw, const string & file_name)
{
  ofstream ofs("temp.xml");
  assert(ofs.good());
  cout<<"now is ok";
  boost::archive::xml_oarchive xml(ofs);
  xml<< boost::serialization::make_nvp("out_Sandwich", sw);
  
}
int main()
{
  string filename("pan12.xml");
  // italian_sandwich isand("shalasandwisuh", "apple", 1);
  // isand.Save(filename);
  char tmpfile[121];
  create_temp_file(filename.c_str(), tmpfile, 121);
  return 0;
}
