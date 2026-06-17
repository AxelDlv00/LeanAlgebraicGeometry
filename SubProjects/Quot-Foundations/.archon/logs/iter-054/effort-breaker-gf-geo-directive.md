# Effort-breaker directive — GF geometric descent

## Target
`lem:gf_section_localization_flat_descent` (B2) in `blueprint/src/chapters/Picard_FlatteningStratification.tex`.
Secondary: surface the finite-basic-open-cover step currently buried inside the proof of
`lem:gf_flat_locality_assembly` ("A spanning family of basic opens") as its own \uses-linked lemma.

## Granularity
Fine — one mathematical claim per lemma. A prior coarse statement of B2 left the GEOMETRIC core (cross-chart
basic-open identification + quasi-compact covering) un-formalizable in one prover pass; split it at the real
scheme-theory seams so each piece is an atomic prover target.

## Why (context)
The ALGEBRA of the source-span descent is DONE & axiom-clean: B1.0 `gf_localizedModule_baseChange_tensor_comm`
and B1 `gf_flat_localizedModule_sameBase`. The Mathlib span criterion `Module.flat_of_isLocalized_span`
(`lem:mathlib_flat_of_isLocalized_span`) is verified present. The prover stopped because B2 and the assembly's
covering step are GEOMETRIC and currently written as monolithic prose. The precise prover handoff:

> prove the cross-chart lemma `X.basicOpen g = X.basicOpen (res_{W→W∩W_j} g)` (the same `X.Opens`), giving the
> `IsLocalizedModule` transport that connects the two `qcoh_section_localization_basicOpen` legs (one in chart
> `W`, one in chart `W_j`); then assemble B2 from the two legs + `IsLocalizedModule.iso` uniqueness.

`lem:qcoh_section_localization_basicOpen` (= QuotScheme `isLocalizedModule_basicOpen`) and
`lem:gf_qcoh_fintype_finite_sections` are both DONE and reusable.

## Proof structure to cut along
B2 currently asserts three things; split into atomic sub-lemmas, each a single claim with its own statement +
one-line informal proof + accurate \uses + a `\lean{AlgebraicGeometry.<PlannedName>}` pin (the Lean decls do
NOT exist yet — name them so the prover builds them):
1. **Cross-chart basic-open identity** — for affine `W`, `W_j` with `D(g) ⊆ W ∩ W_j` (`g ∈ Γ(X,W)`), the open
   `X.basicOpen g` equals `X.basicOpen (ḡ)` where `ḡ ∈ Γ(X,W_j)` is the restriction/image of `g`; i.e. `D(g)`
   is the SAME `X.Opens` whether computed from chart `W` or chart `W_j`. (Pure `Scheme.basicOpen`
   compatibility under restriction — no module content.)
2. **Two-leg `IsLocalizedModule` transport (B2 stmt 1+2)** — `Γ(F,D(g))` is simultaneously
   `(powers g)⁻¹ Γ(F,W)` (leg in chart `W`) and `(powers ḡ)⁻¹ M_j` (leg in chart `W_j`), connected via (1)
   and `IsLocalizedModule.iso` uniqueness. Reuse both legs from `lem:qcoh_section_localization_basicOpen`.
3. **Base comparison (B2 last sentence)** — `Γ(S,U)` is a localization of `A_f` (both localizations of the
   domain `A` inside its fraction field, `U ≤ V = D(f)`); the existing `lem:isLocalization_basicOpen_mathlib`.
4. **Finite spanning basic-open cover (from the assembly proof)** — for affine `W ≤ p⁻¹(U)` with the finite
   affine patch cover `{W_j}` of `p⁻¹(U₀)`, there is a FINITE family `{g_k ∈ Γ(X,W)}` with each
   `D(g_k) ⊆ W ∩ W_{j(k)}` and the `g_k` spanning the unit ideal of `Γ(X,W)` (quasi-compactness of `W` +
   basic opens form a basis). This is the input to `Module.flat_of_isLocalized_span`.

Keep the existing `lem:gf_flat_locality_assembly` statement; repoint its proof + `\uses{}` at the new
sub-lemmas (4) and the recombined B2 (2). Then `thm:generic_flatness` Step 4 consumes the assembly unchanged.

## Constraints
- Cite Nitsure §4 / Hartshorne III.9 where the prose already does; do NOT invent new sources.
- No `\leanok` (sync owns it). No Lean tactic syntax in proofs. `\lean{}` pins on NEW sub-lemmas name the
  planned decl (e.g. `AlgebraicGeometry.gf_crossChart_basicOpen_eq`) so the prover has a target.
- Out of scope: B1/B1.0 (DONE), the algebraic span criterion (Mathlib anchor exists), any stalk phrasing
  (stalk route is DEAD — no `SheafOfModules.stalk`).
