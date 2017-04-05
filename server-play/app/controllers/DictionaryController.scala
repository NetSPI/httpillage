package controllers

import javax.inject._

import play.api._
import play.api.libs.json.Json
import play.api.mvc._

@Singleton
class DictionaryController @Inject() extends Controller {

  def index = Action {
    Ok
  }

  def getDictionary(dictionaryId: Long) = Action {
    Ok
  }

  def create = Action {
    Ok
  }

  def deleteDictionary(dictionaryId: Long) = Action {
    Ok
  }
}
