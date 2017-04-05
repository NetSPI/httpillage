package controllers

import javax.inject._

import play.api._
import play.api.libs.json.Json
import play.api.mvc._

@Singleton
class NodeController @Inject() extends Controller {

  def index = Action {
    Ok(Json.obj("status" -> "ok"))
  }
}
