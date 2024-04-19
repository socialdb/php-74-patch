# MakeコマンドにAWS_PROFILEを渡してね
build: setup build-apache build-alpine cleanup

setup:
	aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 426786900385.dkr.ecr.ap-northeast-1.amazonaws.com

build-alpine:
	docker \
		buildx build \
		-t 426786900385.dkr.ecr.ap-northeast-1.amazonaws.com/phpatch:7.4-alpine \
		--platform "linux/amd64" \
		--progress plain \
		./7.4/alpine3.16/cli \
		--push

build-apache:
	docker \
		buildx build \
		-t 426786900385.dkr.ecr.ap-northeast-1.amazonaws.com/phpatch:7.4-apache \
		--platform "linux/amd64" \
		--progress plain \
		./7.4/bullseye/apache \
		--push

# 本来php公式イメージがサポートしているプラットフォーム
# linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64/v8,linux/ppc64le,linux/s390x
# 
# multi-platformで試した痕跡
# (docker-desktop環境ではつらみ)
#
# docker buildx create --name phpbuilder || true
# docker buildx use phpbuilder
# docker buildx inspect --bootstrap
#	docker run --privileged --rm tonistiigi/binfmt --install all
# docker -H ssh://USER@REMOTE_HOST info
#	docker buildx create \
#		--name arm_remote_builder \
#		--node arm_remote_builder \
#		--platform linux/arm64 \
#		--driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=10000000 \
#		--driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=10000000
#	docker buildx create \
#		--name arm_remote_builder \
#		--append \
#		--node intelarch \
#		--platform linux/arm64 \
#		ssh://ec2-user@35.72.11.197 \
#		--driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=10000000 \
#		--driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=10000000
#	docker buildx use arm_remote_builder
#	docker buildx inspect --bootstrap
# cleanup:
#	docker buildx rm phpbuilder

