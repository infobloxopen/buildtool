PROJECT  := infobloxopen/buildtool

# The list of buildtool versions we are going to build,
# make all versions as phony rules, so we will rebuild
# them every time.
VERSIONS := 0.0.1


.PHONY: all clean $(VERSIONS)
all: $(VERSIONS)


# Create the Docker image with the specified tag.
$(VERSIONS):
	docker build -t $(PROJECT):$@ $@


clean:
	docker rmi -f $(addprefix $(PROJECT),$(VERSIONS))
