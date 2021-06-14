FROM arm64v8/rust AS prepare-env

WORKDIR /opt/rtd1296-synology-rust-builder
COPY . .

FROM prepare-env AS debug-build
RUN cargo build

FROM scratch AS debug
COPY --from=debug-build /opt/rtd1296-synology-rust-builder/target/debug/rtd1296-synology-rust-builder target/arm64v8/debug/