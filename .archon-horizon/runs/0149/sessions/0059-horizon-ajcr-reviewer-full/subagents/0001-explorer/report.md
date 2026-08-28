Read-only extraction completed; no files or inbox state were changed.

**Acceptance chain**

The binding dependency graph is:

`Div^g` representability → `DivRankOneOpen` → `rankOneAbelIso` → `PicRankOneOpen` → translated rank-one cover over `k^s` → `pic0_sepClosed_representableBy` → finite-Galois descent → `pic0_representableBy` → `JacobianData`.

The contract declarations are `PicRankOneOpen`, `DivRankOneOpen`, `rankOneAbel`, `divisorOfRankOne`, `rankOneAbelIso`, `rankOne_translate_cover_sepClosed`, `pic0_sepClosed_representableBy`, and `pic0_representableBy` ([execution plan, pp. 2, 6, 18](</home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/informal/Lean_Algebraic_Jacobian_Complete_Execution_Plan.pdf)).

- `PicRankOneOpen` must be the public family-level locus where `R^1 f_* L = 0`, `f_* L` is locally free rank one, and the required arbitrary base-change compatibility holds.
- `DivRankOneOpen` is the corresponding maximal open in the genus-degree divisor scheme.
- `divisorOfRankOne` must be constructed canonically from the evaluation map, without choosing a generator of `f_* L`; its zero scheme must be finite locally free of degree `g`, base-change compatible, and recover the same Picard class.
- Both inverse identities must be proved, yielding `rankOneAbelIso`; then the open immersion into the Picard functor follows immediately ([pp. 8–9](</home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/informal/Lean_Algebraic_Jacobian_Complete_Execution_Plan.pdf)).

**Anti-vacuity / credit rules**

No credit for:

- existential witnesses that do not explicitly recover the input Picard class;
- zero or unrelated divisors satisfying the conclusion accidentally;
- fieldwise `h⁰ = 1` uniqueness presented as an arbitrary-test natural inverse;
- aliases, wrappers, unused declarations, disconnected carriers, or quotient objects without a genuine universal property;
- new global heartbeat/depth/synthesis limits.

A credited theorem must be in the endgame contract, imported by the narrow critical root, consumed by its immediate downstream theorem, kernel-built, axiom-audited, and accompanied by deletion or specialization of obsolete implementations ([execution plan, pp. 7, 14–15](</home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/informal/Lean_Algebraic_Jacobian_Complete_Execution_Plan.pdf)).

**What remains after `rankOneAbelIso`**

1. Prove separably closed translated coverage:
   `exists_translation_mem_picRankOneOpen`, for every extension `K/k` and Picard class `lam`, producing a base-field line bundle `L0` with `translate L0 lam ∈ PicRankOneOpen`. The witness must remain tied to `lam` and feed the gluing criterion directly (execution plan, p. 9).

2. Apply the open-cover criterion to obtain `pic0_sepClosed_representableBy`, with narrow-root/full-root builds and `#print axioms`; this is the first genuine headline milestone (p. 10).

3. Package the separably closed representative with finite type, properness, group structure, geometric irreducibility, and universal element. Reuse the AJC finite-Galois descent engine to obtain a finite Galois action, cocycle, stable affine cover, invariant affine quotients, gluing, descended universal element, and the final Yoneda certificate. Then define `pic0_representableBy`; the descent theorem must return both scheme and `RepresentableBy` proof and be consumed immediately (pp. 10–11).

4. Define `jacobianData` from that exact same pinned `pic0_representableBy` datum, deriving the identity component, group object, universal element, base-change and cocycle coherence, finite type/properness/smoothness/dimension `g`, Abel–Jacobi map, and Albanese property. Final acceptance requires both roots to build and no project-specific axioms or `sorryAx` (pp. 11–12).

**Current supervision status**

The 7 Aug supervision memo says the remaining shared blocker before the rank-one consumer closes is an honest arbitrary-affine native presentation plus cartesian base-change producer:

- actual family-level `PicRankOneNativePresentation`/`FibrePresented` data;
- base-change comparison morphisms proved `IsIso`;
- tied coherent `H¹ = 0`, rank-one `H⁰`, and native presentations;
- canonical divisor consumer;
- public `PicRankOneOpen`/`DivRankOneOpen` closure and `rankOneAbelIso`.

Runs 122 and 123 correctly stopped without vacuous wrappers or fieldwise substitutions. After that producer lands: run 122 closes openness/base change, run 121 closes the canonical family inverse, run 123 upgrades its translated-cover feeder to public-locus membership; only then should Phases 6–8 activate ([supervision note, pp. 2–5](</home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/informal/AJCR_Runs_121_122_123_Supervision_Note_2026-08-07.pdf)).
