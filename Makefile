IMAGE_NAME ?= golang-test
TESTS = / /go /opt

build:
	echo "Building image.."
	docker build \
        --tag $(IMAGE_NAME) \
		--file Dockerfile .

test: build
	echo "Starting container.."
	docker run \
		-p 8000:8000 \
		--name test-$(IMAGE_NAME) \
		-d --rm $(IMAGE_NAME)
	echo "Running tests"
	$(foreach var,$(TESTS),if [ `curl -o /dev/null -s -w "%{http_code}\n" "localhost:8000$(var)"` -eq 200 ]; then echo ""localhost:8000$(var)" -- ok"; else echo ""localhost:8000$(var)" -- Failed"; fi;)	
	echo "Stopping container.."
	docker stop test-$(IMAGE_NAME) 
	echo "Tests completed"

run: build
	docker run \
		-p 8000:8000 \
		--name test-$(IMAGE_NAME) \
		-d --rm $(IMAGE_NAME)

.PHONY: build test run