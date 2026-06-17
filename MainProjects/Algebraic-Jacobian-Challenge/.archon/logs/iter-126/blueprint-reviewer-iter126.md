# Blueprint Review Report

## Slug
iter126

## Iteration
126

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` / `\thm{thm:rigidity_over_kbar}`: hypothesis list and source-curve framing in the chapter do not match the Lean signature it claims to name. Chapter states source as `\mathbb P^1_{\bar k}` throughout (statement + C.2.b + C.2.c) but the Lean target `AlgebraicGeometry.rigidity_over_kbar` (at `AlgebraicJacobian/RigidityKbar.lean:75`) takes a generic `C : Over (Spec (.of kbar))` with `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` plus the bare hypothesis `(_hgenus : genus C = 0)`. The "Encoding choice" docstring in the Lean file (lines 32–46) acknowledges and motivates the Option B encoding (Mathlib `b80f227` has no `ProjectiveSpace n S` scheme constructor; literal `MvPolynomial`-Spec is the affine, not projective, line); the chapter carries no parallel disclosure. The `genus C = 0` hypothesis is therefore both (a) unmentioned in the chapter's statement of Theorem~\ref{thm:rigidity_over_kbar} and (b) the load-bearing typeclass-substitute for "the source is `\mathbb P^1_{\bar k}`."

- `Differentials.tex` / proof-prose `\lean{...}` refs: three prose-only `\lean{...}` references (`AlgebraicGeometry.IsAffineOpen.appLE_unitSubmonoid` at L136; `AlgebraicGeometry.IsAffineOpen.appLE_colimRingHom_comp_φV` at L151; `AlgebraicGeometry.IsAffineOpen.isUnit_appLE_unitSubmonoid_in_colim` at L167) still lack dedicated `\begin{lemma}` / `\begin{definition}` blocks. The directive's "five" count is one off (it appears to also count `kaehler_localization_subsingleton` and `kaehler_quotient_localization_iso`, which DO have dedicated `\begin{lemma}` blocks at L193–L222). Carry-forward under M1 PARKED status; not a prover blocker this iter.

### Proofs lacking detail

- `RigidityKbar.tex` / `\thm{thm:rigidity_over_kbar}` proof decomposition C.2.c: the dichotomy "image is dimension 0 or 1" needs to cite the proper-image-of-irreducible-is-irreducible-closed fact (one line in `Cohomology.image_irreducible_of_proper` or similar Mathlib gap-fill). Currently the dichotomy is stated, not justified. Acceptable as proof sketch but a prover would need to disambiguate which Mathlib lemma underlies the "irreducible closed subset of $A$" assertion.

- `RigidityKbar.tex` § Shared pile piece (iii): the three options on the table (Frobenius iteration / Mumford no-rational-curves / Wittlift) are listed but the decision criterion is deferred to the iter-126 mathlib-analogist consult. This is appropriate for an iter-126 scoping chapter, but downstream provers will need a follow-on writer pass once the analogist returns.

### Lean difficulty quality

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.rigidity_over_kbar}`: target exists but its actual signature diverges from the chapter prose by adding the `genus C = 0` hypothesis and dropping the literal-`\mathbb P^1` source typing. A prover (e.g. an iter-127 lane on the body) reading only the chapter would be unaware of the `_hgenus` argument and the curve-as-abstract-genus-0 encoding. Mathematically equivalent in conclusion (since over an algebraically closed field with a `\bar k`-point any smooth proper geometrically irreducible curve of genus 0 is `\mathbb P^1_{\bar k}`), but the encoding choice is load-bearing for the proof strategy and must be in the blueprint, not buried in a Lean docstring.

- `Jacobian.tex` § C.2.g phantom-name `AlgebraicGeometry.AbelianVariety.constant_of_P1_map`: phantom (final name TBD), declaring the full keystone. `RigidityKbar.tex` shared-pile piece (i) `AlgebraicGeometry.AbelianVariety.cotangent_trivial` / `GroupScheme.Omega_trivial` is one *ingredient*, not the keystone itself. The decomposition is internally coherent (piece (i)+(ii)+(iii) → `constant_of_P1_map`), but the cross-ref between the C.2.g phantom name and the pile-piece phantom names is not explicit in either chapter. Soon-item, not must-fix.

### Multi-route coverage

- Route "M2.a body — shared cotangent-vanishing pile (M2.d-alt collapsed)": **PARTIAL** — covered by `RigidityKbar.tex` § "Shared cotangent-vanishing Mathlib pile" with the four-piece (i)–(iv) decomposition. Piece (i) cotangent triviality, piece (ii) df=0 ⇒ factor, piece (iii) char-p handling, piece (iv) Serre duality (used by M2.d-alt only, correctly disclosed). Per-piece LOC estimates (200–400 each) are stated. The decomposition is honest. Awaits iter-126 mathlib-analogist scoping output for char-p option pick (Frobenius / Mumford / Witt lift).

- Route "M2.d RR path": **MISSING** — STRATEGY.md still lists this as an alternative to M2.d-alt (table § M2 Decomposition). No chapter covers Riemann–Roch over `\bar k`, divisor module, RR space, Serre duality for curves separately from the shared pile. Acceptable because the strategy's "Choosing the M2.d variant" defers the decision to iter-130+, and current sequencing favors M2.d-alt; should the iter-130+ decision flip to RR path, blueprint coverage would need to land before any prover on M2.d. Informational this iter.

- Route "Direct over-k rigidity (drops M2.c)" — STRATEGY.md § "Alternative: direct over-k rigidity": **MISSING** in blueprint. The alternative is flagged for user/mathematician confirmation in `TO_USER.md`, so no chapter coverage is required this iter; if the user adopts it, a writer pass on `RigidityKbar.tex` would be needed to drop the "over $\bar k$" framing.

- Route "M3 positive-genus witness — Route A (Picard scheme)" and "Route B (symmetric powers + Stein)": both **MISSING** in blueprint as standalone chapters. M3 work is off-loop this iter (user-hint absorbed: "do the work, no axioms" path; M3 stays off the iter-by-iter critical path until M2 closes). The two routes are documented in `Jacobian.tex` § Existence of an Albanese variety (Route A and Route B sub-step expansions, plus Mathlib-status bullets). Acceptable as informational coverage; standalone chapters would land if/when an iter dispatches an M3 prover.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All blocks formalized; `\lean{...}` hint targets exist in `AlgebraicJacobian/Cohomology/SheafCompose.lean`.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three blocks (sheafification, $\Ext$, `toAbSheaf`) all complete and correctly cross-referenced.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Long chapter, many blocks; producer + consumer pipeline for wholespace Hom-finiteness coherent; \v{C}ech / Mayer–Vietoris carriers correctly forward-reference `Cohomology_MayerVietoris.tex`.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:Scheme_AffineCoverMVSquare_corners` (L444) lacks `\leanok` while the four individual corner-identification lemmas L451–L508 each carry `\leanok`. This is intentional (the omnibus block is a free remark; the substantive statements are the four split lemmas) but a future stylistic pass could either drop the omnibus block or replace it with a `\begin{remark}` to avoid the appearance of an unmarked theorem. Informational.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three prose-only `\lean{...}` refs at L136, L151, L167 still lack dedicated blocks (`appLE_unitSubmonoid`, `appLE_colimRingHom_comp_φV`, `isUnit_appLE_unitSubmonoid_in_colim`). Soon-item; carry-forward under M1 PARKED status (no prover on Differentials.lean this iter).
  - The bridge `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE` (L113–L125) and its M1.b sub-lemma `lem:appLE_isLocalization` (L154–L186) describe a multi-step proof that the Lean side currently has only as a residual single `sorry` at `AlgebraicJacobian/Differentials.lean:398` (per `rem:m1_parked_iter125`). This matches STRATEGY.md § M1's "PARKED iter-125" framing.
  - STRATEGY.md § M1 reads as "EXCISED iter-126" (with M1 bridge + 7 declarations deleted), but the Lean tree still contains all seven declarations. This is a STRATEGY.md/reality drift, not a blueprint defect; flagged in "Cross-chapter notes" below. The blueprint's references currently resolve cleanly against the Lean tree.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Definition of `genus` plus three equivalent reformulations and Mathlib-gap section. Coherent.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Long chapter covering protected `Jacobian` instances + `nonempty_jacobianWitness` Route A / Route B / genus-0 sub-case (C.1–C.3 + C.2.a–C.2.g). The C.2.b reduction correctly cites `thm:GrpObj_eq_of_eqOnOpen` (the iter-125 refactored `Scheme.Over.ext_of_eqOnOpen`).
  - C.2.g records the phantom statement `AlgebraicGeometry.AbelianVariety.constant_of_P1_map` for the full keystone. RigidityKbar.tex's shared-pile pieces (i)–(iii) are the ingredients of this keystone; the cross-reference is implicit, not explicit. Soon-item.
  - The chapter is internally consistent and the C.2 sub-step labelling is correctly mirrored in `RigidityKbar.tex`'s proof decomposition.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Statement of `thm:GrpObj_eq_of_eqOnOpen` correctly mirrors the iter-125-landed Lean signature of `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` (reduced source / separated target; group-object decoration dropped).
  - § "Use in the project" L52–L59 names M2.a as a downstream consumer but routes through "Jacobian.tex § C.2.b" only. The new `RigidityKbar.tex` chapter is not cross-referenced as an additional consumer of `thm:GrpObj_eq_of_eqOnOpen`. Soon-item: the "Use" bullet 1 should add a reference to `chap:RigidityKbar` (or to `thm:rigidity_over_kbar` directly) so the reader sees the new keystone-scaffold chapter as a use-site.
  - Legacy label `thm:GrpObj_eq_of_eqOnOpen` not renamed to `thm:Scheme_Over_ext_of_eqOnOpen`; cross-refs from `Jacobian.tex` and `AbelJacobi.tex` still resolve via the legacy label. Soon-item carry-forward.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **(must-fix)** Theorem~\ref{thm:rigidity_over_kbar} (L16–L27) states the source as `\mathbb P^1_{\bar k}`, but the named Lean target at `AlgebraicJacobian/RigidityKbar.lean:75` actually takes a generic `C : Over (Spec (.of kbar))` with `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` plus `(_hgenus : genus C = 0)`. The `genus C = 0` hypothesis is absent from the chapter's hypothesis list. The "Encoding choice" rationale (Option A vs Option B) is documented in the Lean file's docstring (lines 32–46) but not in the chapter. A prover dispatched on the body of `rigidity_over_kbar` (e.g. an iter-127 lane redirected from M2.b to M2.a per the contingency the directive flags) reading only the chapter would write a target that does not match the actual signature.
  - **(must-fix-coverage)** The proof decomposition § "Proof decomposition" reuses the `\mathbb P^1_{\bar k}` framing in C.2.b and C.2.c. The C.2.c "image dimension argument" uses "$\mathbb P^1_{\bar k}$ has dimension 1" — true and correctly stated in chapter prose, but a prover trying to formalize this against the Lean signature would need to instead use "$C$ has relative dimension 1 over `kbar`" (from the `SmoothOfRelativeDimension 1 C.hom` typeclass), which the chapter does not call out.
  - The shared cotangent-vanishing pile section (L55–L76) decomposes the keystone into pieces (i)–(iv) with per-piece LOC estimates. Piece (iv) Serre duality is correctly disclosed as used by M2.d-alt only, not by C.2.d — matches the directive's check item.
  - § "Use in the project" L78–L85 names M2.b (genus-0 witness) as the in-tree consumer; correctly cross-references `\cref{rem:Galois_descent_morphism_equality}` from Jacobian.tex § C.2.f. **Note**: that `\cref{rem:Galois_descent_morphism_equality}` label does not exist in `Jacobian.tex` (no `\label{rem:Galois_descent_morphism_equality}` appears anywhere in the blueprint). The closest concept is the C.2.f sub-step (L319–L352 of `Jacobian.tex`) which has no `rem:` label of its own. **Broken cross-ref — must-fix.**
  - § "Mathlib status" framing aligns with STRATEGY.md § M2.a + M2.d-alt and § "Soundness rules" (no-axiom path).

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three protected declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) each project from the Albanese witness; correct.
  - The "Classical description" paragraph in the proof of `thm:exists_unique_ofCurve_comp` (L82) references genus-0 sub-case "C.2.a–C.2.g" — consistent with the corresponding labels in `Jacobian.tex`. Acceptable narrative.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true (relative to the chapter's content as a historical artifact)
- **correct**: true (statements are mathematically correct)
- **notes**:
  - Orphan chapter: describes `AlgebraicJacobian/Modules/Monoidal.lean` which is **not in the current Lean tree**. Confirmed by listing `AlgebraicJacobian/` (only Cohomology/, Differentials, Rigidity, RigidityKbar, Genus, Jacobian, AbelJacobi present). Not included in `content.tex`. Informational carry-forward.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true (relative to historical state)
- **correct**: true (statements are mathematically correct)
- **notes**:
  - Orphan: describes `AlgebraicJacobian/Picard/LineBundle.lean` (or similar) which is **not in the current Lean tree**. Not included in `content.tex`. Informational carry-forward.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true (relative to historical state)
- **correct**: true (statements are mathematically correct)
- **notes**:
  - Orphan: describes `AlgebraicJacobian/Picard/Functor.lean` (or similar) which is **not in the current Lean tree**. Not included in `content.tex`. Informational carry-forward.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true (relative to historical state)
- **correct**: true (statements are mathematically correct)
- **notes**:
  - Orphan: describes `AlgebraicJacobian/Picard/FunctorAb.lean` (or similar) which is **not in the current Lean tree**. Not included in `content.tex`. Informational carry-forward.

## Cross-chapter notes

- **RigidityKbar.tex ↔ Lean signature drift**: the chapter's Theorem~\ref{thm:rigidity_over_kbar} states the source as `\mathbb P^1_{\bar k}`; the named Lean target uses a generic `C` with `genus C = 0`. The encoding choice rationale (Option B — Mathlib `b80f227` has no `Scheme`-packaged `ProjectiveSpace n S`) lives in `AlgebraicJacobian/RigidityKbar.lean:32–46` only.

- **RigidityKbar.tex ↔ Jacobian.tex § C.2.f**: `RigidityKbar.tex` § "Use in the project" cites `\cref{rem:Galois_descent_morphism_equality}` from Jacobian.tex. This label does not exist anywhere in the blueprint. The closest matching content is `Jacobian.tex` § C.2.f (L319–L352) which has no `rem:` label. Broken cross-reference — must-fix.

- **Rigidity.tex ↔ RigidityKbar.tex**: Rigidity.tex § "Use in the project" L56–L58 names M2.a as a downstream consumer via "Jacobian.tex § C.2.b". With the new `RigidityKbar.tex` chapter, the cross-reference should add `\cref{chap:RigidityKbar}` or `\cref{thm:rigidity_over_kbar}` as a second use-site for `thm:GrpObj_eq_of_eqOnOpen`. Soon-item.

- **Jacobian.tex § C.2.g ↔ RigidityKbar.tex shared pile**: the C.2.g phantom name `AlgebraicGeometry.AbelianVariety.constant_of_P1_map` (Jacobian.tex L356) is the high-level keystone, decomposed in RigidityKbar.tex pieces (i)–(iii). The decomposition is consistent but the cross-ref between the two phantom-name layers is implicit. Soon-item.

- **STRATEGY.md ↔ Lean reality (informational, not a blueprint defect)**: STRATEGY.md § M1 declares "Status: EXCISED iter-126" describing the deletion of 7 declarations from `Differentials.lean` (lines 80–89). The current Lean tree still contains all seven (the M1.b sorry at `AlgebraicJacobian/Differentials.lean:398` is present; `appLE_unitSubmonoid`, `appLE_colimRingHom`, `appLE_colimAlgebra`, `appLE_colimRingHom_comp_φV`, `isUnit_appLE_unitSubmonoid_in_colim`, `appLE_isLocalization`, `relativeDifferentialsPresheaf_equiv_kaehler_appLE` all present). STRATEGY.md and the iter-126 directive disagree on the M1 excise dispatch (directive lists only one refactor: `m2a-scaffold-iter126`; STRATEGY.md describes a separate `refactor-m1-excise-iter126` dispatch). Surface this to the plan agent so STRATEGY.md narrative can be brought back in line with Lean reality.

## Strategy-modifying findings (if any)

None this iter. The strategy is internally consistent on the M2.a / M2.d-alt route choice; the user-hint absorption (no-axiom path) is reflected in both STRATEGY.md § "Soundness rules" and RigidityKbar.tex § "Mathlib status".

## Severity summary

- **must-fix-this-iter** (3 items):
  - `RigidityKbar.tex` is `complete: partial / correct: partial` because the chapter's stated theorem hypotheses and source-curve framing do not match the named Lean target signature (missing `genus C = 0` hypothesis; encoding choice not disclosed in chapter). A dispatch of a blueprint-writer this iter should either (a) restate Theorem~\ref{thm:rigidity_over_kbar} on a generic genus-0 curve and update the proof decomposition prose, or (b) add a clearly-marked encoding-choice remark in the chapter explaining the Option A / Option B trade-off and making the `genus C = 0` hypothesis visible in the formal statement. Per the directive's check ("`RigidityKbar.tex` is complete:true + correct:true so iter-127's potential prover lane on `rigidity_over_kbar` body is not blocked by a blueprint gap"), this is gating: any iter-127 redirect to the M2.a body (the directive flags this as contingent) must be deferred until the writer pass lands.
  - `RigidityKbar.tex` § "Use in the project" cites `\cref{rem:Galois_descent_morphism_equality}` which is a broken cross-reference — the label does not exist in any chapter. Same writer dispatch should fix this.
  - The shared-pile piece (iii) char-`p` handling lists three options (Frobenius / Mumford / Witt lift) without picking one; the directive notes this is for the iter-126 mathlib-analogist consult to scope. Not blocking iter-126 (no prover on the shared pile this iter), but the iter-127+ plan-agent should fold the analogist's choice into a writer pass before any prover lane on piece (iii) opens.
- **soon** (4 items):
  - `Rigidity.tex` § "Use in the project" cross-reference to `chap:RigidityKbar` missing (bullet 1 currently routes via Jacobian.tex § C.2.b only).
  - `Jacobian.tex` C.2.g phantom-name `AlgebraicGeometry.AbelianVariety.constant_of_P1_map` ↔ `RigidityKbar.tex` shared-pile piece (i) `AlgebraicGeometry.AbelianVariety.cotangent_trivial` cross-ref not made explicit.
  - `Rigidity.tex` legacy label `thm:GrpObj_eq_of_eqOnOpen` not yet renamed to `thm:Scheme_Over_ext_of_eqOnOpen` despite the iter-125 refactor changing the Lean name.
  - `Differentials.tex` three prose-only `\lean{...}` refs at L136, L151, L167 still lack dedicated blocks (carry-forward under M1 PARKED).
- **informational** (2 items):
  - Four orphan chapters (`Modules_Monoidal.tex`, `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`) describe Lean files no longer in the tree; not in `content.tex`; carry-forward.
  - STRATEGY.md § M1 narrative ("EXCISED iter-126") drifts from current Lean reality (the seven declarations still present in `Differentials.lean`). This is a STRATEGY.md issue, not a blueprint defect; surface to the plan agent.

Overall verdict: blueprint is largely healthy with one must-fix iter-126 defect (the RigidityKbar.tex theorem-vs-Lean signature drift + broken `rem:Galois_descent_morphism_equality` cross-ref), which gates any iter-127 redirect to the M2.a body but does not block iter-127's M2.b scaffold per current STRATEGY.md sequencing.
