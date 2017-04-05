package controllers

import javax.inject._

import play.api._
import play.api.libs.json.Json
import play.api.mvc._

@Singleton
class BruteforceProgressController @Inject() extends Controller {

  def getProgress(jobId: Int) = Action {
    Ok
  }
}
