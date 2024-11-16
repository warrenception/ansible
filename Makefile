.PHONY: build run test clean

# Variables
USER_NAME = warrenception
IMAGE_NAME = warrenception
CONTAINER_NAME = warrenception-test
ANSIBLE_TAGS ?= 

default: clean build

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

# Run ansible playbook with optional tags and keep shell open
run:
	make
	docker run -it \
		--name $(CONTAINER_NAME) \
		$(IMAGE_NAME) /bin/bash -c "ansible-playbook $(ANSIBLE_TAGS) setup.yml -vv && sudo -iu $(USER_NAME)"

# Clean up docker resources
clean:
	docker rm -f $(CONTAINER_NAME) 2>/dev/null || true
	docker rmi $(IMAGE_NAME) 2>/dev/null || true