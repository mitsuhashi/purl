docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from clone_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from users;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from group_maintainer_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from group_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from domain_maintainer_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from domain_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from domain_writer_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from purl_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from purl_maintainer_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from purl_history_infos;"

docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from clone_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from users;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from group_maintainer_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from group_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from domain_maintainer_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from domain_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from domain_writer_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from purl_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from purl_maintainer_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from purl_history_infos;"