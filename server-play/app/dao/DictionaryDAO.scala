package dao

import javax.inject.Inject

import entity.Dictionary
import org.joda.time.DateTime
import play.api.db.slick.{DatabaseConfigProvider, HasDatabaseConfigProvider}
import slick.driver.JdbcProfile
import com.github.tototoshi.slick.PostgresJodaSupport._

import scala.concurrent.Future

/**
  * Created by jpoulin on 3/25/17.
  */
class DictionaryDAO @Inject()(protected val dbConfigProvider: DatabaseConfigProvider) extends HasDatabaseConfigProvider[JdbcProfile] {
  import driver.api._

  val dictionaries = TableQuery[DictionaryTable]
  def all(): Future[Seq[Dictionary]] = db.run(dictionaries.result)

  def getDictionaryById(id: Long) = db.run(dictionaries.filter(_.id === id).result.headOption)

  def create = db.run(DBIO.seq(dictionaries.schema.create))

  def insert(dictionary: Dictionary) = db.run(dictionaries returning dictionaries.map(n => (n)) += dictionary)

  def delete(dictionaryId: Long) = db.run(dictionaries.filter(_.id === dictionaryId).delete)

  class DictionaryTable(tag: Tag) extends Table[Dictionary](tag, "DICTIONARIES") {

    def id = column[Long]("ID", O.PrimaryKey, O.AutoInc)

    def fileName = column[String]("FILENAME")
    def originalFileName = column[String]("ORIGINALFILENAME")
    def description = column[String]("DESCRIPTION")
    def sizeInBytes = column[Long]("SIZEINBYTES")
    def createdAt = column[DateTime]("CREATEDAT")
    def updatedAt = column[DateTime]("UPDATEDAT")

    def * = (id, fileName, originalFileName, description, sizeInBytes, createdAt, updatedAt) <> (Dictionary.tupled, Dictionary.unapply _)

  }
}