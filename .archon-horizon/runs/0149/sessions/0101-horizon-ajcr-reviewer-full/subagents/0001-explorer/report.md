## PDF Acceptance Audit

- `rankOneAbelIso` must be a natural arbitrary-test-scheme isomorphism built from the canonical evaluation divisor, with no generator choice. Prove finite locally free degree `g`, arbitrary base change, Picard-class compatibility, and both inverse laws. (Plan pp. 7-8, 17; Memo p. 4)
- The shared arbitrary-affine producer must tie native presentation, `H¹ = 0`, rank-one finite-projective `H⁰`, and cartesian base-change isomorphisms to the same family. Fieldwise results are insufficient. (Memo pp. 1-4)
- The isomorphism must immediately produce `rankOneAbel_isOpenImmersion` and be consumed by the public rank-one loci. (Plan pp. 8, 13-15)
- Separably closed coverage must be input-related, land in the actual public locus, and produce `pic0_sepClosed_representableBy`. (Plan pp. 8-10; Memo pp. 3-5)
- Finite-Galois descent must reuse AJC infrastructure and return both the descended scheme and its `RepresentableBy` certificate, immediately consumed by `pic0_representableBy`. (Plan pp. 9-11, 13)
- `pic0_representableBy` and `jacobianData` must use one pinned representation. Group structure, universal element, base change, and cocycle coherence cannot come from independently chosen representatives. (Plan pp. 4, 10-12)
- The entire chain must be imported by the narrow critical root and full AJCR/AJC roots. All builds must pass, and axiom audits must give exactly `[propext, Classical.choice, Quot.sound]`. (Plan pp. 4-5, 9, 11, 14-15)
- The PDFs name `jacobianData` as the endpoint, not `Challenge.lean`; the task’s Challenge headline must therefore be a root-reachable consumer of that same datum, not a parallel witness.

Forbidden shortcuts include high-degree direct Abel injectivity, fieldwise-to-family wrappers, generator selection, unrelated existential carriers, unconsumed aliases, duplicate AJCR descent, quotient fallback without a non-circular universal-property contract, and new global elaboration limits. (Plan pp. 3, 5-8, 10-16; Memo pp. 1, 3-5)

Memo p. 7 warns that its historical build claims were not independently rerun, so every gate requires fresh verification. No files were changed.
