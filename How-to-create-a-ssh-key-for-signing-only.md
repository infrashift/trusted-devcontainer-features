# Create a SSH Key for Signing Git Commits

To create an SSH key specifically for signing commits, you can use the `-O` flag with `no-pty`, `no-X11-forwarding`, `no-agent-forwarding`, and `no-port-forwarding` options in your `ssh-keygen` command. This will create a key with limited capabilities, only allowing it to be used for signing.

Here's an example of how you can modify the provided statement:

```bash
ssh-keygen -t ed25519 -C "<comment>" -O no-pty -O no-X11-forwarding -O no-agent-forwarding -O no-port-forwarding
```

This command generates an `Ed25519` key pair with the given comment and the specified options that restrict its usage to signing only. After running the command, you will be prompted to provide a file name and passphrase. The generated public key (e.g., `id_ed25519.pub`) can then be added to the `authorized_keys` file on the target machine, with the specified restrictions.

NOTE: It is important to note that the `-O` options in the ssh-keygen command do not enforce the restrictions on the generated key itself. These options should be included when adding the public key to the `authorized_keys` file on the remote machine, like this:

```
no-pty,no-X11-forwarding,no-agent-forwarding,no-port-forwarding ssh-ed25519 AAAAC3... user@hostname
```

So, when you create the key pair, use the original command:

```bash
ssh-keygen -t ed25519 -C "<comment>"
```

And when adding the public key to the authorized_keys file on the target machine, include the options as shown above.