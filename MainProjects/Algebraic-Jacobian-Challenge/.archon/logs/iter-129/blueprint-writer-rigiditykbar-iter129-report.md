# Blueprint Writer Report

## Slug
rigiditykbar-iter129

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/RigidityKbar.tex`

## Changes Made

### A. Renamed (i.a) lemma block: `lem:GrpObj_lieAlgebra` → `lem:GrpObj_cotangentSpace`

- **Renamed** human-readable name `[(i.a) Lie algebra of a group scheme at the identity]` → `[(i.a) Cotangent space at the identity of a group scheme]`.
- **Renamed** `\label{lem:GrpObj_lieAlgebra}` → `\label{lem:GrpObj_cotangentSpace}`.
- **Updated** `\lean{AlgebraicGeometry.GrpObj.lieAlgebra}` → `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (matches the iter-129 parallel refactor lane in `AlgebraicJacobian/Cotangent/GrpObj.lean`).
- **Added inline signature stub** as a LaTeX comment under the `\lean{...}` hint, pinning the relaxed `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` binder (verbatim text reproduced below in § "Signature stubs added").
- **Rewrote** the lemma's main prose: dropped the "Lie algebra is $\mathfrak g$, its dual is $\mathfrak g^\vee$" framing; the lemma is now stated *about* $\mathfrak g^\vee$ (the cotangent), with one line noting that $\mathfrak g = \mathrm{Hom}_k(\mathfrak g^\vee, k)$ is recovered externally.
- **Rewrote** the Lean encoding note (formerly "iter-128 per blueprint-reviewer + strategy-critic"): now pins the dualisation convention — the Lean declaration returns the un-dualised $\mathfrak g^\vee$ directly (no internal `Module.Dual`); consumers needing $\mathfrak g$ take `Module.Dual k (cotangentSpaceAtIdentity G)` externally. Cross-references the new bridge lemma + the renamed rank lemma.
- **Rewrote** the proof block: removed the phantom `IsRegularLocalRing.cotangentSpace` reference; the proof now points to the bridge lemma (\cref{lem:GrpObj_cotangent_bridge}) for the connection between the iter-128 evaluate-then-extend-scalars body and $\mathfrak m_{\eta_G}/\mathfrak m_{\eta_G}^2$, and names `Ideal.IsLocalRing.CotangentSpace` as the correct Mathlib anchor (defined as `(maximalIdeal R).Cotangent` in `Mathlib.RingTheory.Ideal.Cotangent`).

### B. New lemma block: `lem:GrpObj_cotangent_bridge` (the bridge lemma)

- **Added** a new `\begin{lemma}...\end{lemma}` block titled `[(i.a-bridge) Bridge to the local-ring cotangent space at the identity]` between `lem:GrpObj_cotangentSpace` and `lem:GrpObj_lieAlgebra_finrank`.
- **Label**: `\label{lem:GrpObj_cotangent_bridge}`.
- **Lean target**: `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent}` (iter-130+ build target, not yet in Lean).
- **Inline signature stub** added as a LaTeX comment under the `\lean{...}` hint (verbatim below).
- **`\uses{lem:GrpObj_cotangentSpace}`** in both the lemma header and the proof.
- **Lemma statement**: canonical $k$-linear isomorphism $\mathfrak g^\vee \xrightarrow{\sim} \mathfrak m_{\eta_G}/\mathfrak m_{\eta_G}^2$, with the RHS = `Ideal.IsLocalRing.CotangentSpace` applied to the stalk $\mathcal O_{G, \eta_G}$.
- **Proof sketch**: two-step decomposition closely following the directive's template:
  1. Step 1 (localisation kills relative differentials): $k \otimes_{\Gamma(G,\mathcal O_G)} (\Omega_{G/k})(G) = k \otimes_{\mathcal O_{G,\eta_G}} \Omega_{\mathcal O_{G,\eta_G}/k}$ via the residue-map factorisation $\Gamma(G,\mathcal O_G) \to \mathcal O_{G,\eta_G} \to k$ + `Algebra.FormallyUnramified.subsingleton_kaehlerDifferential` (already cross-referenced as `lem:kaehler_localization_subsingleton` of Differentials.tex).
  2. Step 2 (Stacks Tag 02G1 identification): $k \otimes_R \Omega_{R/k} \cong \mathfrak m/\mathfrak m^2$ for a local $k$-algebra $(R, \mathfrak m, k)$ with residue map a $k$-algebra retraction. Names `Ideal.IsLocalRing.CotangentSpace` and `Algebra.Extension.CotangentSpace` as Mathlib anchors.
- The proof explicitly notes that **no regularity input is needed for the bridge itself** — regularity enters only at the rank step.

### C. Rewrote rank lemma `lem:GrpObj_lieAlgebra_finrank` (label unchanged; Lean name + proof updated)

- **Renamed** human-readable name `[(i.a) Rank of the Lie algebra]` → `[(i.a) Rank of the cotangent space at the identity]`.
- **Kept label** `\label{lem:GrpObj_lieAlgebra_finrank}` per directive scope (the directive explicitly listed only the `\label{lem:GrpObj_lieAlgebra}` rename and the cross-references that need updating).
- **Updated `\lean{...}`** hint from `AlgebraicGeometry.GrpObj.lieAlgebra_finrank_eq_dim` to `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq` (aligns with the iter-129 Lean file's status docstring, which already names the rank-lemma successor as `cotangentSpaceAtIdentity_finrank_eq`).
- **Added inline signature stub** as a LaTeX comment (verbatim below).
- **Updated `\uses{}`** in both the lemma header and proof: now `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_cotangent_bridge}` (bridges to the new (i.a) label + the new bridge lemma).
- **Rewrote the statement**: now $\finrank_k\,\mathfrak g^\vee = n$ as the primary claim with the dual statement $\finrank_k\,\mathfrak g = n$ as a consequence (was previously stated symmetrically); pins to relative dimension $n$ from `[SmoothOfRelativeDimension n G.hom]` instance (unchanged content).
- **Rewrote the proof** as a 4-step closure with explicit Mathlib anchors, mirroring the level of detail in `Differentials.tex`'s `thm:smooth_locally_free_omega` proof (the "model of detail" reference). Steps:
  1. Bridge to $\mathfrak m_{\eta_G}/\mathfrak m_{\eta_G}^2$ via `lem:GrpObj_cotangent_bridge`, anchored on `Ideal.IsLocalRing.CotangentSpace`.
  2. Regularity of the local ring at the identity: smooth ⇒ `IsRegularLocalRing` (Stacks 00TR / Hartshorne II.10.3.B); Krull dim = relative dim $n$ (Stacks 02G1).
  3. Cotangent rank = Krull dim for regular local rings (definitional property of `IsRegularLocalRing`).
  4. Cross-check via the affine-chart route: `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` + `\cref{thm:smooth_locally_free_omega}` (in `AlgebraicJacobian/Differentials.lean` as `smooth_locally_free_omega`). Notes that this route is alternative — the bridge-via-regular-local-ring route is preferred as more directly aligned with the iter-128 body.
- Closing dual-rank step: $\finrank_k\,\mathfrak g = \finrank_k\,\mathfrak g^\vee = n$ via rank-equals-rank-of-dual.
- "Mathlib name summary" paragraph (mirroring the `Differentials.tex` model) listing the 4 closure pieces: `Ideal.IsLocalRing.CotangentSpace`, `IsRegularLocalRing`, the Krull-dim-equals-cotangent-rank fact, `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` + `thm:smooth_locally_free_omega`.

### D. Updated `\uses{}` cross-references across the chapter

All `\uses{lem:GrpObj_lieAlgebra}` sites updated to `\uses{lem:GrpObj_cotangentSpace}`:
- `lem:GrpObj_mulRight_globalises` (shear-iso) header — line 180 → now `\uses{lem:GrpObj_cotangentSpace}`.
- Proof of `lem:GrpObj_mulRight_globalises` — now `\uses{lem:GrpObj_cotangentSpace}`.
- `lem:GrpObj_omega_free` (i.c freeness) header — now `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_mulRight_globalises}`.
- Proof of `lem:GrpObj_omega_free` — now `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_mulRight_globalises}` + the in-prose `\cref{lem:GrpObj_lieAlgebra}` updated to `\cref{lem:GrpObj_cotangentSpace}`.
- `rem:piece_i_first_target` header — now `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_cotangent_bridge, lem:GrpObj_lieAlgebra_finrank}` (also wired in the new bridge lemma).
- The `\uses{lem:GrpObj_omega_free, lem:GrpObj_lieAlgebra_finrank}` sites on `lem:GrpObj_omega_rank_eq_dim` and its proof were already `lem:GrpObj_lieAlgebra_finrank` (rank lemma label unchanged); no edit needed there.

### E. Stripped the `% NOTE (iter-128 review):` block

The long `% NOTE (iter-128 review):` comment block immediately preceding the (i.a) lemma block (former line 92) was deleted. Its content (two iter-129 must-fix items) is now reflected in the rewritten chapter:
- Item (i) (signature relaxation) → reflected in the new `\lean{...}` signature stub on `lem:GrpObj_cotangentSpace`.
- Item (ii) (dualisation convention) → reflected in the rewritten Lean encoding note on `lem:GrpObj_cotangentSpace` and the cleanup of the lemma prose to position the lemma about $\mathfrak g^\vee$ (un-dualised).

### F. Updated the "Iter-128 prover lane re-scoping" paragraph

The "Iter-128 prover lane re-scoping" paragraph (formerly line 88, now under "Iter-128 / iter-129 prover lane re-scoping") was updated to reflect the iter-129 rename + the 3-target trio structure (was a 2-target pair). All `\cref{lem:GrpObj_lieAlgebra}` references inside that paragraph were updated to `\cref{lem:GrpObj_cotangentSpace}`. The Lean-name string `lieAlgebra` was updated to `cotangentSpaceAtIdentity` in the body, and the placeholder `\texttt{lieAlgebra}` retained in one historical-narrative sentence so the reader can trace the iter-128 → iter-129 transition. The bridge lemma is mentioned in the trio.

### Strike check on phantom Mathlib name

The phantom `IsRegularLocalRing.cotangentSpace` appeared only in the former proof of `lem:GrpObj_lieAlgebra` (line 108 of the pre-edit file). It is **gone**: all references to the cotangent module of a regular local ring now read `Ideal.IsLocalRing.CotangentSpace` (the verified Mathlib name, defined as `(maximalIdeal R).Cotangent` in `Mathlib.RingTheory.Ideal.Cotangent`). Verified via `lean_local_search` against the Mathlib snapshot (the search returned `Ideal.IsLocalRing.CotangentSpace` as an `abbrev` in that file; the phantom name returned nothing).

## Cross-references introduced

- `\uses{lem:GrpObj_cotangent_bridge}` (new label) wired into:
  - The rank lemma `lem:GrpObj_lieAlgebra_finrank` header and proof.
  - `rem:piece_i_first_target` header.
  - In-prose `\cref{lem:GrpObj_cotangent_bridge}` mentions in the rewritten (i.a) lemma encoding note + proof, and in the rank lemma proof (Step 1).
- The bridge lemma itself uses `\uses{lem:GrpObj_cotangentSpace}` (the (i.a) renamed label). The bridge proof additionally cites `\cref{lem:kaehler_localization_subsingleton}` from `Differentials.tex` for the localisation-kills-differentials step — that label exists in `Differentials.tex` (verified by grep on the chapters directory).
- All previously-`lem:GrpObj_lieAlgebra` `\uses{}` sites updated to `lem:GrpObj_cotangentSpace`; no orphan `\uses{lem:GrpObj_lieAlgebra}` remains.

## Signature stubs added (verbatim)

On `lem:GrpObj_cotangentSpace`:
```latex
% Lean signature stub (pinned post-iter-129 fixup; relaxed from the
% iter-128 hardcoded rel-dim-1 form so the same declaration serves
% consumers of arbitrary relative dimension, e.g. \cref{thm:rigidity_over_kbar}
% applied to an abelian variety of dimension $g$):
%   noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
%       [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
%       [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k
```

On `lem:GrpObj_cotangent_bridge` (new):
```latex
% Lean signature stub (iter-130+ build target; bridges the iter-128 body
% construction to the local-ring cotangent space supplied by Mathlib):
%   noncomputable def cotangentSpaceAtIdentity_iso_localRingCotangent
%       (G : Over (Spec (.of k)))
%       [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
%       [IsProper G.hom] [GeometricallyIrreducible G.hom] :
%       cotangentSpaceAtIdentity G ≅
%         ModuleCat.of k (Ideal.IsLocalRing.CotangentSpace
%           (R := Scheme.stalk G.left (η_G.left.base ⟨_, trivial⟩)))
```

On `lem:GrpObj_lieAlgebra_finrank`:
```latex
% Lean signature stub (iter-130+ rank-lemma build target; depends on the
% bridge lemma \cref{lem:GrpObj_cotangent_bridge} plus the regular-local-ring
% + standard-smooth rank-pinning Mathlib pieces named in the proof):
%   theorem cotangentSpaceAtIdentity_finrank_eq (G : Over (Spec (.of k)))
%       [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
%       [IsProper G.hom] [GeometricallyIrreducible G.hom] :
%       Module.finrank k (cotangentSpaceAtIdentity G) = n
```

## Macros needed

None new. All macros used (`\GrpObj`, `\Over`, `\Spec`, `\pr`, `\finrank`, `\cref`, `\genus`, `\thm`) were already in use in the pre-edit chapter.

## Reference-retriever dispatches

None. The Mathlib name `Ideal.IsLocalRing.CotangentSpace` was verified directly via `lean_local_search` against snapshot `b80f227`; the bridge-lemma references (Stacks Tag 02G1, Hartshorne II.8 Prop 8.7 / II.10) are cited inline by tag/section per project convention (existing chapters cite Stacks/Hartshorne the same way).

## Validation

- **LaTeX `\begin{}...\end{}` balance**: verified balanced via a Python script run on the post-edit file (`balance check OK`, no unmatched environments).
- **`\uses{}` graph well-formedness**: every `\uses{lem:GrpObj_cotangentSpace}`, `\uses{lem:GrpObj_cotangent_bridge}`, `\uses{lem:GrpObj_lieAlgebra_finrank}`, `\uses{lem:GrpObj_mulRight_globalises}`, `\uses{lem:GrpObj_omega_free}` resolves to a `\label{...}` defined within the same chapter. The bridge proof's `\cref{lem:kaehler_localization_subsingleton}` resolves to a label in `Differentials.tex` (verified by grep).
- **No remaining phantom `IsRegularLocalRing.cotangentSpace`**: verified by grep — only `Ideal.IsLocalRing.CotangentSpace` appears.
- **No orphan `\cref{lem:GrpObj_lieAlgebra}` or `\uses{lem:GrpObj_lieAlgebra}`**: verified by grep with negative-lookahead. Surviving `lieAlgebra` mentions are intentional: the unchanged label `lem:GrpObj_lieAlgebra_finrank` for the rank lemma + two historical-narrative sentences explicitly noting the iter-128 → iter-129 rename (in the re-scoping paragraph and the rank-lemma encoding note, where the prose explicitly says "iter-128 placeholder `lieAlgebra_finrank_eq_dim`").
- **`leanblueprint checkdecls`**: ran successfully. The output lists pre-existing missing declarations (`Scheme.IsAffineHModuleHomFinite`, `Scheme.basicOpenCover*`, `Scheme.cotangentExactSeq*`, etc. — unrelated to this writer pass; these come from other chapters' deferred declarations). Critically, neither `GrpObj.cotangentSpaceAtIdentity` nor the two new iter-130+ targets (`cotangentSpaceAtIdentity_iso_localRingCotangent`, `cotangentSpaceAtIdentity_finrank_eq`) appear in the output: this is because `blueprint/lean_decls` is stale (not re-built from the new chapter), not because the names are wrong. Re-running after a `leanblueprint web` or `leanblueprint pdf` will surface them as expected failures per the directive — the bridge lemma and rank lemma are explicitly iter-130+ build targets, and (per the directive) the rename of `lieAlgebra` → `cotangentSpaceAtIdentity` was specifically called out as "EXPECTED for this iter since refactor + writer run in parallel". Importantly, the iter-129 refactor lane has already landed in `AlgebraicJacobian/Cotangent/GrpObj.lean` (the file now defines `cotangentSpaceAtIdentity`, per `lean_local_search`); so once `blueprint/lean_decls` is regenerated, the (i.a) `\lean{}` hint should resolve cleanly. The two iter-130+ targets will remain as expected `checkdecls` failures until the iter-130+ prover lanes author them.

## Notes for Plan Agent

- **`lem:GrpObj_lieAlgebra_finrank` label was NOT renamed.** The directive's "## What to write" section listed only the (i.a) lemma label rename (`lem:GrpObj_lieAlgebra` → `lem:GrpObj_cotangentSpace`) and explicitly enumerated the `\uses{}` sites needing the rename. The rank lemma's `lem:GrpObj_lieAlgebra_finrank` label was not on that list. For internal consistency one might rename it to `lem:GrpObj_cotangentSpace_finrank` in a follow-up writer pass, but doing so would touch 6+ cross-references in the chapter and was out-of-scope per the directive's "stick to what the directive listed under 'Required content'" rule.
- **The legacy `kbar` variable name in the Lean signature** (`[Field kbar]`) is acknowledged in the chapter introduction as a low-priority iter-130+ cleanup and the directive explicitly marked it as out-of-scope for this writer pass. No edit made.
- **The bridge lemma's Lean target name** (`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent`) is a writer-chosen name and is not yet locked to a Mathlib-snapshot declaration. The iter-130+ prover lane may want to rename it (e.g. shorter: `cotangentSpaceAtIdentity_iso_cotangentSpace`) once the bridge is being authored — flagging this so the rename can land then without a writer round-trip.
- **The proof of `lem:GrpObj_lieAlgebra_finrank`** names a "Krull-dimension-equals-cotangent-rank fact attached to `IsRegularLocalRing`" without pinning a precise Mathlib decl. This is because the regularity-defining property is packaged differently across `RingTheory.RegularLocalRing.Defs` versus the cotangent-side abbreviations in `Ideal.Cotangent`. The iter-130+ rank-lemma prover lane should expect to do a brief `lean_local_search` round to lock the exact Mathlib name (candidates: `IsRegularLocalRing.finrank_cotangentSpace_eq_krullDim` or similar); I deliberately left the name unpinned because picking a wrong name in the chapter is worse than naming the fact without a pin.

## Strategy-modifying findings

None. The directive's anchor `Ideal.IsLocalRing.CotangentSpace` is present in Mathlib snapshot `b80f227` (verified via `lean_local_search`); no strategy-level re-routing required.
