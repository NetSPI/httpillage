package services

import javax.inject.Inject

import entity.Dictionary

import dao.DictionaryDAO
import scala.concurrent.{Await, Future}

/**
  * Created by jpoulin on 4/6/17.
  */
class DictionaryService @Inject()(dictionaryDAO: DictionaryDAO) {
  def getDictionaries = {
    dictionaryDAO.all()
  }

  def getDictionaryById(id: Long): Future[Option[Dictionary]] = {
    dictionaryDAO.getDictionaryById(id)
  }
}
