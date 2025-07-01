# Base image for ARMv7 (32-bit)
FROM arm32v7/debian:bullseye-slim

# Install necessary software
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    nano \
    curl \
    net-tools \
    apt-utils \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Although this didn't fix the core issue, it's still good practice.
RUN chmod u+s /usr/bin/sudo

# Create standard 'pi' user and add to sudo group
RUN useradd -m -s /bin/bash pi && \
    adduser pi sudo

# --- FINAL WORKAROUND: Configure passwordless sudo for the 'pi' user ---
# This creates a sudoers rule to bypass the broken authentication.
RUN echo 'pi ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/pi-nopasswd

# Set passwords (though we will now bypass the sudo password)
RUN echo 'root:raspberry' | chpasswd
RUN echo 'pi:raspberry' | chpasswd

# Configure SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN mkdir -p /run/sshd
EXPOSE 22

# Command to run when the container starts
CMD ["/usr/sbin/sshd", "-D"]
