
// @GENERATOR:play-routes-compiler
// @SOURCE:/Users/jpoulin/dev/httpillage/server-play/conf/routes
// @DATE:Wed Apr 05 10:17:27 EDT 2017


package router {
  object RoutesPrefix {
    private var _prefix: String = "/"
    def setPrefix(p: String): Unit = {
      _prefix = p
    }
    def prefix: String = _prefix
    val byNamePrefix: Function0[String] = { () => prefix }
  }
}
