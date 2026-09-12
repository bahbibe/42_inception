FROM alpine:3.23

# the alpine mariadb package ships tooling a container never runs: the test
# binary, the embedded server, the rocksdb tools and the aria/myisam utilities
RUN apk add --no-cache mariadb mariadb-client && \
	cd /usr/bin && rm -f \
		test-connect-t mariadb-embedded mariadb-ldb sst_dump \
		aria_read_log aria_pack aria_ftdump aria_dump_log aria_s3_copy \
		myisampack myisam_ftdump myisamlog \
		mariadb-slap mariadb-conv mariadb-waitpid mariadb-import

COPY ./tools/setup.sh /setup.sh

CMD ["/setup.sh"]
