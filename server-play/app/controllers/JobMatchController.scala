package controllers

import javax.inject._

import play.api._
import play.api.libs.json.Json
import play.api.mvc._

@Singleton
class JobMatchController @Inject() extends Controller {

  def create(jobId: Long) = Action {
    Ok
  }
}
