/**
 * \file example.h
 *
 * \ingroup Example
 * 
 * \brief Class def header for a class example
 *
 * @author kazuhiro
 */

/** \addtogroup Example

    @{*/
#ifndef __EXAMPLE_EXAMPLE_H__
#define __EXAMPLE_EXAMPLE_H__

#include <vector>

namespace Example {

  /**
     \class example
     User defined class example ... these comments are used to generate
     doxygen documentation!
  */
  class example{
    
  public:
    
    /// Default constructor
    example(){}
    
    /// Default destructor
    ~example(){}

    inline std::vector<float> get_vector() const
    { return std::vector<float>(10,0.); }
    
  };
}

#endif
/** @} */ // end of doxygen group 

