TARGET = nanobt

BUILD_DIR = build

INC_DIR = . \

SRC_MAIN = \
	src/main.c \

SRCS = \
	$(SRC_MAIN) \

CFLAGS += -std=c99 $(addprefix -I,$(INC_DIR))


OBJS=$(addprefix $(BUILD_DIR)/,$(patsubst %.c,%.o,$(SRCS)))
DEPS=$(patsubst %.o,%.d, $(OBJS))

all: $(BUILD_DIR) $(TARGET)
 
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(TARGET) : $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

$(BUILD_DIR)/%.o : %.c
	mkdir -p $(dir $@); \
	$(CC) -c $(CFLAGS) -o $@ $<
 
$(BUILD_DIR)/%.d : %.c
	mkdir -p $(dir $@); \
	$(CC) -MM $(CFLAGS) $< \
	| sed 's/$(notdir $*).o/$(subst /,\/,$(patsubst %.d,%.o,$@) $@)/' > $@ ; \
	[ -s $@ ] || rm -f $@

clean:
	rm -rf $(BUILD_DIR) $(TARGET)
