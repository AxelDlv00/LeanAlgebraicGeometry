# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-review132

## Iteration
132

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean`
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` (Piece (i.a), § `subsec:RigidityKbar_piece_i_decomposition`)

## Naming-asymmetry note (directive-requested)

There is intentionally NO `AlgebraicJacobian_Cotangent_GrpObj.tex` chapter. Piece (i.a) — the content corresponding to `Cotangent/GrpObj.lean` — lives inside the broader `RigidityKbar.tex` chapter alongside the other piece-(i) decomposition (i.b shear globalisation, i.c cotangent freeness/rank). The cross-referencing works correctly via the `\lean{...}` hints (`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`, `…_finrank_eq`, `…_iso_localRingCotangent`, etc.) which target the exact Lean names regardless of host chapter. This audit verified the file-vs-piece-(i.a) mapping without any tooling confusion: locating the relevant blocks in `RigidityKbar.tex` by greppable `\lean{AlgebraicGeometry.GrpObj.*}` hints was straightforward. **Not a defect**, but worth recording for future readers who may grep for a same-named `.tex` chapter and find none.

## Per-declaration

The chapter contains four `\lean{...}` hints in the `GrpObj.*` namespace. Two target declarations in this file; the other two target stubs declared `\notready` and intentionally absent from this file (per directive: do not flag).

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (chapter: `lem:GrpObj_cotangentSpace`)
- **Lean target exists**: yes — `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` at line 149.
- **Signature matches**: yes — the Lean signature is identical to the blueprint stub (lines 100–102 of the chapter):
  ```
  noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
      [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
      [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k
  ```
  Confirmed via LSP outline: `(G : Over (Spec (CommRingCat.of k))) → [GrpObj G] → {n : ℕ} → [SmoothOfRelativeDimension n G.hom] → [IsProper G.hom] → [GeometricallyIrreducible G.hom] → ModuleCat k`.
- **Proof follows sketch**: yes (definition body). The body realises the blueprint's "Replacement (B): affine-chart base change" construction step-for-step:
  - Step 1 of the blueprint's proof body: extract `ηleft : Spec k ⟶ G.left` from the GrpObj identity section — matches Lean lines 153–154.
  - Step 2: get `x₀ := ηleft default` — matches line 156.
  - Step 3: `Classical.choose`-chain on `Scheme.smooth_locally_free_omega` for `(U, V, e, hxV)` — matches lines 162–168, with each let-binding named to keep the outer expression in pure-term shape (iter-131 body refactor, explicitly authorised by the chapter prose at lines 121 / 303–307).
  - Step 4: build `ψV` from the appLE of `ηleft` restricted to `V`, composed with `Scheme.ΓSpecIso` — matches lines 174–177.
  - Step 5: extend scalars on `Ω[Γ(G,V) / Γ(Spec k, U)]` along `ψV` — matches lines 187–188.
- **Notes**: The chart `V` is non-canonical (chosen by `Classical.choose`); this is openly disclosed both in the docstring (lines 128–142) and in the blueprint (lines 120–122). The structural-shape exposure is witnessed by the companion lemma `cotangentSpaceAtIdentity_eq_extendScalars` (see below).

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}` (chapter: `lem:GrpObj_lieAlgebra_finrank`)
- **Lean target exists**: yes — `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq` at line 244.
- **Signature matches**: yes — the Lean theorem statement matches the blueprint stub (lines 186–189):
  ```
  theorem cotangentSpaceAtIdentity_finrank_eq (G : Over (Spec (.of k)))
      [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
      [IsProper G.hom] [GeometricallyIrreducible G.hom] :
      Module.finrank k (cotangentSpaceAtIdentity G) = n
  ```
  The Lean version writes `cotangentSpaceAtIdentity (n := n) G` (explicit named arg) because `n` is implicit in `cotangentSpaceAtIdentity` and Lean cannot infer it from `G`; this is purely a Lean-elaboration nuance — same proposition.
  Naming-drift check (directive-requested): the legacy slug `lem:GrpObj_lieAlgebra_finrank` is preserved as the TeX label, but the `\lean{...}` hint correctly points to the new Lean name `cotangentSpaceAtIdentity_finrank_eq` (line 182 of the chapter). The chapter's encoding-note paragraph (lines 198 of `lem:GrpObj_lieAlgebra_finrank`) explicitly documents the iter-129 rename. **Not a flag** — the rename is properly threaded.
- **Proof follows sketch**: yes. The Lean proof (lines 247–282) realises the blueprint's Steps 1+2 live closure path:
  - Setup: reproduces the same `Classical.choose`-chain as the body of `cotangentSpaceAtIdentity` to bind `U`, `V`, `e`, `hxV` (Lean 249–255; blueprint Step 1 paragraph at lines 206 / 247–255).
  - Algebra structures: `algGV : Algebra Γ(Spec k, U) Γ(G, V)` and `algGVk : Algebra Γ(G, V) k` (Lean 257–258, 270) — match the body's `letI` and the blueprint's `ψV` setup.
  - Extracts `hfree` and `hrank` from the same existential payload (Lean 260–263; blueprint Step 1's `hfree` / `hrank` (lines 207–212)).
  - `Nontrivial Γ(G, V)` from `ψV.hom.domain_nontrivial` (line 272) — matches the blueprint's "discharging the `Module.Free` hypothesis ... and the `Nontrivial Γ(G, V)` hypothesis from the existence of the ring map ψ_V" (lines 242–243 of the chapter docstring at the top of this Lean file, mirroring blueprint Step 2 lines 217–223).
  - Goal reduction via `change` to `Module.finrank k (TensorProduct Γ(G,V) k Ω[…]) = n` (Lean 276–277) — uses definitional equality of the body's carrier with the tensor product; the blueprint's recommended pattern (lines 303–307) would route through `cotangentSpaceAtIdentity_eq_extendScalars` for an explicit `rw [heq]`, but the direct `change` route is mathematically equivalent. See minor flag in the "Blueprint adequacy" section below.
  - Step 2: `Module.finrank_baseChange` (Lean 279–280; blueprint Step 2 lines 217–227 — exact lemma name match).
  - Step 1 close: `Module.finrank_eq_of_rank_eq hrank` (Lean 282; blueprint Step 1 line 212 — exact lemma name match).
- **Notes**: Step 4 of the blueprint (dualisation conclusion `finrank g = n`) is informational on the tangent side and not in scope for this rank lemma — Lean correctly stops at Step 2. Step 3 of the blueprint is explicitly an "alternative canonical route, currently deferred" and is correctly NOT in the Lean proof. No mathematical-content divergence detected.

## Red flags

None. No `:= sorry`, no `:= True` / `:= rfl` shortcuts, no excuse-comments, no axioms, no unauthorised `Classical.choice` on substantive claims. The `Classical.choose`-chain in the body of `cotangentSpaceAtIdentity` and the proof of `cotangentSpaceAtIdentity_finrank_eq` is the iter-131 deliberate body shape, explicitly authorised by the blueprint's chapter prose (lines 121, 159–169, 303–307) and called out in the directive as "not a suspect body".

## Unreferenced declarations (informational)

One in-file declaration is not `\lean{...}`-referenced by the chapter:

- **`cotangentSpaceAtIdentity_eq_extendScalars`** (theorem, line 198). This is a defensive companion lemma that witnesses the iter-131 body's structural shape — it exposes the chart triple `(U, V, e)`, a top-inclusion `htop`, and the explicit equation `cotangentSpaceAtIdentity G = (ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])`. The chapter mentions this lemma by name in three places:
  - The proof of `lem:GrpObj_cotangentSpace` at line 121: "see... the companion lemma `cotangentSpaceAtIdentity_eq_extendScalars` for the structural-shape rewrite handle".
  - The proof of `lem:GrpObj_lieAlgebra_finrank` at line 206: "the same charts are pinned by the body of `lem:GrpObj_cotangentSpace` via the iter-131 `Classical.choose`-chain and re-extractable through the companion lemma `cotangentSpaceAtIdentity_eq_extendScalars`".
  - The footer paragraph at line 307 ("Iter-131 `Classical.choose`-chain body shape"): "The companion lemma `cotangentSpaceAtIdentity_eq_extendScalars` witnesses this structural shape via an existential ... closed essentially by `rfl` once the same `Classical.choose`-chain is unpacked on the right-hand side."

Since the blueprint explicitly names this lemma three times as a structural-shape witness and prescribes a downstream rewrite pattern that routes through it, it would be reasonable to promote it to its own `\lean{...}` block in the chapter (e.g., as a sub-paragraph of `lem:GrpObj_cotangentSpace` or as a numbered helper lemma). Flagged as minor below.

## Blueprint adequacy for this file

A bidirectional check: does the blueprint chapter give a prover enough detail to formalize this file correctly?

- **Coverage**: 2/3 substantive Lean declarations have a corresponding `\lean{...}` block in the chapter (`cotangentSpaceAtIdentity` ↔ `lem:GrpObj_cotangentSpace`; `cotangentSpaceAtIdentity_finrank_eq` ↔ `lem:GrpObj_lieAlgebra_finrank`). The third declaration (`cotangentSpaceAtIdentity_eq_extendScalars`) is referenced by name in three blueprint prose passages but lacks its own `\lean{...}` block — see "Unreferenced declarations" above. 0 helpers, 1 substantive-but-unblocked.
- **Proof-sketch depth**: adequate. The chapter's proof bodies for `lem:GrpObj_cotangentSpace` (5-step construction at lines 115–119) and `lem:GrpObj_lieAlgebra_finrank` (Steps 1+2 at lines 206–229, with all consumed Mathlib lemma names spelled out: `Module.finrank_eq_of_rank_eq`, `Module.finrank_baseChange`, `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`, `Algebra.IsStandardSmooth.free_kaehlerDifferential`, `Algebra.TensorProduct.instFree`) gave the prover everything needed to formalize this file. The Mathlib-name summary at lines 239 is particularly load-bearing.
- **Hint precision**: precise. Every `\lean{...}` hint in the chapter targets an exact Lean name; the signature stubs in the `% Lean signature stub` comments (lines 96–102 and 184–189) match the actual Lean signatures verbatim (modulo the implicit-vs-explicit `(n := n)` cosmetic difference noted above). No "smooth morphism" vs `SmoothOfRelativeDimension n` ambiguity — the chapter pins `SmoothOfRelativeDimension n G.hom` consistently.
- **Generality**: matches need. The free `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` binder is what `thm:rigidity_over_kbar` needs to instantiate at `n = g := dim A` for the abelian-variety consumer; the encoding note at line 198 of the chapter explicitly authorises this generality choice (rejecting a hardcoded `n = 1` form). The `ModuleCat k` return type (not `Module k`, not `Type u`) matches the iter-129 dualisation pinning at lines 109 of the chapter.
- **Recommended chapter-side actions**:
  - **Minor**: promote `cotangentSpaceAtIdentity_eq_extendScalars` to its own `\lean{...}` block (e.g., as a small helper-lemma block under `lem:GrpObj_cotangentSpace`, or as a standalone `lem:GrpObj_cotangentSpace_extendScalars_witness`). It's mentioned by name three times in the chapter and is the structural-shape contract that the iter-131 fix-up exists to deliver — a `\lean{...}` block would make the existential statement explicit and let `sync_leanok` track its formalisation status.
  - **Minor**: the chapter's recommended rewrite pattern at line 307 (`obtain ⟨U, V, e, htop, heq⟩ := cotangentSpaceAtIdentity_eq_extendScalars G`, then `rw [heq]` and re-extract `hfree`/`hrank`) describes a different proof skeleton than what the iter-132 Lean prover actually used. The Lean rank lemma takes a more direct route: it duplicates the `Classical.choose`-chain (so chart witnesses are syntactically the *same* term as the body's, not merely equal-by-`heq`) and uses `change` to reduce definitionally, never invoking the companion lemma. Both approaches are mathematically equivalent — definitional reduction succeeds because the body and the companion lemma's RHS share the same `Classical.choose`-chain term. The chapter could either (a) update the recommended pattern to describe the direct `change` route, or (b) keep the `obtain`+`rw [heq]` pattern as one acceptable option among several. Not blocking; just a documentation-vs-implementation drift to track.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - `cotangentSpaceAtIdentity_eq_extendScalars` is named three times in the chapter prose but lacks its own `\lean{...}` block. Promoting it to a numbered helper lemma would close the blueprint↔Lean reference for this declaration and let `sync_leanok` track its `\leanok` status.
  - Documentation drift: the chapter's recommended downstream rewrite pattern at line 307 routes through the companion lemma; the iter-132 Lean rank-lemma proof uses a direct `change`-based route instead. Both work and produce the same proof. Worth tracking, not worth blocking on.

Overall verdict: **The Lean file faithfully implements the iter-131 Replacement (B) construction described in piece (i.a) of `RigidityKbar.tex`, and the iter-132 rank lemma's proof matches the blueprint's Steps 1+2 closure path; the only flag-worthy items are a missing `\lean{...}` block for the companion structural-shape lemma and a small Lean-vs-prose proof-skeleton drift, both minor.**
