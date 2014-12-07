.pragma library

var systemType = "Symbian"
var style = {}

Object.defineProperties(style, {
                            metroTitleFontPointSize:{
                                get: function(){
                                         return systemType == "Symbian"?11:15
                                       }
                            },

                            newsListFontPointSize:{
                                get: function(){
                                          return systemType == "Symbian"?7:12
                                        }
                            }
                        })
