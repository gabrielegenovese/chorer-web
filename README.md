# Chorer Web

_Chorer Web_ is the web interface for **Chorer**, a static analysis tool for reasoning about message-passing concurrency in Erlang systems.  
The core Chorer project is available [here](https://github.com/gabrielegenovese/chorer).

This web frontend provides:

- A browser-based Erlang code editor with syntax highlighting.
- Automatic extraction of Local Views and Global Views.
- Interactive visualization of the resulting DOT graphs.
- Built-in example loader for quick experimentation.

---

## Running the Project for development

Clone the repository and start the Phoenix server:

```bash
sudo systemctl start postgresql
mix deps.get
mix phx.server
```
