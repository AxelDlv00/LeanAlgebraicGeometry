# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-review129

## Iteration
129

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean`
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (chapter: `\lem:GrpObj_cotangentSpace`)
- **Lean target exists**: yes (line 102 of `Cotangent/GrpObj.lean`; LSP-confirmed signature, no `sorry`).
- **Signature matches**: yes. LSP returns
  `(G : Over (Spec (CommRingCat.of k))) → [GrpObj G] → {n : ℕ} → [SmoothOfRelativeDimension n G.hom] → [IsProper G.hom] → [GeometricallyIrreducible G.hom] → ModuleCat k`,
  which is character-for-character the blueprint signature stub at lines 100–102 of `RigidityKbar.tex`. The iter-129 rename (`lieAlgebra` → `cotangentSpaceAtIdentity`) and the relaxation from a hardcoded relative-dimension `1` to a free `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` binder are reflected on both sides.
- **Proof follows sketch**: yes (this is a `def` body, not a proof). The body's four-step construction documented in the Lean docstring (`η_G : 𝟙_ → G` → ring map `ψ : Γ(G.left, ⊤) → k` via `appTop ≫ ΓSpecIso` → `relativeDifferentialsPresheaf G.hom` at `op ⊤` → `ModuleCat.extendScalars ψ.hom`) is exactly the construction summarised in the chapter's `\begin{proof}` of `lem:GrpObj_cotangentSpace` (lines 112–120): "extension of scalars to k, along the ring map ψ : Γ(G, 𝒪_G) → k induced by η_G on global sections, of the global-sections module of the relative cotangent presheaf … `k ⊗_{Γ(G, 𝒪_G)} (Ω_{G/k})(G)`".
- **notes**:
  - The blueprint lemma *also* states "is a finitely generated free `k`-module"; the Lean target only encodes existence as a `ModuleCat k` value. Per the chapter's own framing (line 119: "Combining with the bridge lemma yields the finitely-generated-free claim for `g^∨`"), the f.g.-free claim is delivered downstream by `lem:GrpObj_cotangent_bridge` + `lem:GrpObj_lieAlgebra_finrank`, both iter-130+ targets. The Lean signature stub (lines 100–102) also returns just `ModuleCat k`, so this is an intentional decoupling, not a Lean-side over-claim.
  - The Lean docstring forward-references `cotangentSpaceAtIdentity_finrank_eq` (the rank lemma `lem:GrpObj_lieAlgebra_finrank`) but does **not** forward-reference `cotangentSpaceAtIdentity_iso_localRingCotangent` (the new bridge `lem:GrpObj_cotangent_bridge`). This is a minor cross-reference gap on the Lean side; see "Unreferenced declarations / cross-ref gaps" below.

(No other `\lean{...}` blocks in `RigidityKbar.tex` target a declaration that should live in this file. The remaining `\lean{...}` hints in the chapter point at `cotangentSpaceAtIdentity_iso_localRingCotangent`, `cotangentSpaceAtIdentity_finrank_eq`, `mulRight_globalises_cotangent`, `omega_free`, `omega_rank_eq_dim`, all flagged in the directive as intentional iter-130+ targets, plus `rigidity_over_kbar` which is the M2.a top-level declaration owned elsewhere.)

## Red flags

### Placeholder / suspect bodies
- None on the Lean side. The body of `cotangentSpaceAtIdentity` is fully elaborated (no `:= sorry`, no `:= True`, no suspect `:= rfl`), and the construction it executes matches the prose. The body's *mathematical correctness* (a separate concern raised by `mathlib-analogist-lieAlgebra-rank-bridge-iter129` and explicitly out-of-scope for this file-vs-chapter check, per the directive) is **not** re-flagged here.

### Excuse-comments
- None. The Lean file's "Status" docstring (lines 28–39) and the in-body comments (lines 106–115) are descriptive, not excuse-style.

### Axioms / `Classical.choice` on non-trivial claims
- None.

## Unreferenced declarations / cross-ref gaps (informational)

- The Lean file contains **exactly one substantive declaration** (`cotangentSpaceAtIdentity`), which is `\lean{...}`-pinned. No unreferenced helpers.
- **Minor Lean-side cross-ref gap**: the docstring of `cotangentSpaceAtIdentity` should also mention the iter-130+ bridge `cotangentSpaceAtIdentity_iso_localRingCotangent` (parallel to the rank-lemma forward-reference on lines 25–26 and 68–71). The bridge is what justifies the finitely-generated-free claim that the blueprint attaches to `lem:GrpObj_cotangentSpace`; readers of the Lean docstring currently see only the rank lemma referenced, which under-states the iter-130+ surface.

## Blueprint adequacy for this file

- **Coverage**: 1/1 substantive Lean declarations have a `\lean{...}` block (`lem:GrpObj_cotangentSpace` ↔ `cotangentSpaceAtIdentity`). The chapter additionally hosts three forward `\lean{...}` hints (bridge / rank / globalisation) for declarations not yet in this file — appropriately marked `\notready` (the rank lemma) or annotated with iter-130+ schedule prose (the bridge), with cross-references in `\rem:piece_i_first_target`.
- **Proof-sketch depth**: adequate for the iter-128 body construction. The chapter's `\begin{proof}` of `lem:GrpObj_cotangentSpace` (lines 112–120) gives the exact four-step recipe the Lean body executes; a prover could have re-derived the body from the prose. The bridge proof (lines 144–161) likewise gives a two-step ring-level outline (localisation kills relative differentials → standard `k ⊗_R Ω_{R/k} ≅ 𝔪/𝔪²` identification) that is detailed enough for an iter-130+ prover.
- **Hint precision**: precise. The signature stubs in the `%` comment blocks under each `\lean{...}` hint pin every binder (including the relaxed `{n : ℕ}` form and the typeclass list) verbatim. This is exemplary for a prover-handoff: the iter-129 rename + relaxation propagated cleanly into the stubs.
- **Generality**: matches need. The relaxation to a free `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` binder is mirrored across (i.a), (i.a-bridge), and (i.a-rank), so the abelian-variety consumer `rigidity_over_kbar` (relative dimension `g`) can instantiate the same declaration without a parallel API.

### Drift: iter-128 body framed as canonical (per directive, flag this)

The directive flags one explicit thing to check: whether the chapter still presents the iter-128 body as the canonically-correct sheaf object, rather than as the *current Lean encoding* that the iter-130 prover lane is scheduled to swap out via Replacement (B). The chapter currently does present it as canonical:

- **lem:GrpObj_cotangentSpace proof (line 115)**: "The iter-128 Lean construction *realises* `η_G^* Ω_{G/k}` as the extension of scalars …". The verb "realises" frames the body as the canonical pullback, not as a placeholder.
- **lem:GrpObj_cotangentSpace proof (line 117)**: states the body is `g^∨ ≅ k ⊗_{Γ(G,𝒪_G)} (Ω_{G/k})(G)` without any caveat that this realisation may collapse to zero for the actual `[SmoothOfRelativeDimension n G.hom]` consumer class.
- **lem:GrpObj_cotangent_bridge proof (line 160)**: "the bridge is a **tautological** identification of two constructions of the same `k`-module, valid for any group scheme with an identity section in `Over (Spec k)`". If the iter-128 body is mathematically degenerate (the separate critical finding the directive cites), then this "tautological" framing is positively wrong: the bridge becomes a non-trivial *replacement*, not a tautology.
- **lem:GrpObj_cotangent_bridge statement (line 141)**: "the left-hand side is the iter-128 evaluate-then-extend-scalars Lean body of `\cref{lem:GrpObj_cotangentSpace}`" — describes the body as the canonical LHS of the bridge iso, again without acknowledging it is a placeholder pending replacement.

The chapter SHOULD instead document the iter-128 body as the **current Lean encoding** (not as a canonically-correct realisation of `η_G^* Ω_{G/k}`), and frame `lem:GrpObj_cotangent_bridge` as the iter-130 *Replacement (B)* path that pins the canonical cotangent — not as a tautological identification of two equal-by-construction objects.

### Recommended chapter-side actions

- In `lem:GrpObj_cotangentSpace`'s proof, replace "*realises* `η_G^* Ω_{G/k}` as …" with "*currently encodes* `η_G^* Ω_{G/k}` as …" (or equivalent hedge) and add a one-sentence note that the iter-130 prover lane is scheduled to replace the body via Replacement (B), with the canonical RHS supplied by `lem:GrpObj_cotangent_bridge`.
- In `lem:GrpObj_cotangent_bridge`'s proof, drop the word "tautological" (line 160) and recast the bridge as the canonical *replacement* path that pins the correct cotangent. Keep the two-step decomposition; just stop claiming it is content-free.
- In `lem:GrpObj_cotangent_bridge`'s statement, hedge "the left-hand side is the iter-128 evaluate-then-extend-scalars Lean body" → "the left-hand side is the iter-128 placeholder Lean body (scheduled for iter-130 replacement)".
- Optional minor: add `\notready` to `lem:GrpObj_cotangent_bridge` (consistent with `lem:GrpObj_lieAlgebra_finrank` on line 174); the bridge has no Lean counterpart yet and presently carries no marker.

### Recommended Lean-side action

- In the docstring of `cotangentSpaceAtIdentity` (lines 62–101 of `Cotangent/GrpObj.lean`), add a forward-reference to `cotangentSpaceAtIdentity_iso_localRingCotangent` (the iter-130+ bridge) alongside the existing `cotangentSpaceAtIdentity_finrank_eq` reference, so the docstring exposes the full iter-130 follow-on surface.

## Severity summary

- **must-fix-this-iter**: none. The Lean signature matches the blueprint stub verbatim, the body construction matches the prose recipe, no `sorry` / placeholder / excuse-comment / axiom on the Lean side, and the bridge / rank gaps are intentionally iter-130+ per the directive.
- **major**:
  1. Blueprint prose in `lem:GrpObj_cotangentSpace` and `lem:GrpObj_cotangent_bridge` frames the iter-128 body as the canonical realisation of `η_G^* Ω_{G/k}` and the bridge as a tautological identification; the directive explicitly asks for this drift to be flagged so the chapter reflects the body as the **current Lean encoding** (iter-130 replacement target) rather than as a canonically-correct sheaf object. Recommended fixes listed above; the cleanup is a blueprint-writer task for iter-130 prep, not a same-iter gate.
- **minor**:
  1. Lean docstring missing the bridge-lemma forward-reference (already covers the rank lemma).
  2. `lem:GrpObj_cotangent_bridge` carries no `\notready` marker; sibling `lem:GrpObj_lieAlgebra_finrank` (also no Lean counterpart) does.

**Overall verdict**: Lean and blueprint are signature-aligned and structurally coherent for the (i.a) `cotangentSpaceAtIdentity` declaration; the only substantive finding is the chapter's *prose framing* of the iter-128 body as canonically realising `η_G^* Ω_{G/k}` (and the bridge as tautological), which the directive flags as drift to correct in the blueprint for iter-130 prep.
