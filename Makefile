PROJECT  := infobloxopen/buildtool

# The list of buildtool versions we are going to build,
# make all versions as phony rules, so we will rebuild
# them every time.
VERSIONS := v1
LATEST   := v1


.PHONY: all clean latest $(VERSIONS)
all: $(VERSIONS) latest


# Create the Docker image with the specified tag.
$(VERSIONS):
	docker build -t $(PROJECT):$@ $@


latest:
	docker build -t $(PROJECT):$@ $(LATEST)


clean:
	docker rmi -f $(addprefix $(PROJECT),$(VERSIONS))
