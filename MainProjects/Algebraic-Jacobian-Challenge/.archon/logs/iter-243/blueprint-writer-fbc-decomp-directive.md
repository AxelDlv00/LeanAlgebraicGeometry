# blueprint-writer directive — Cohomology_FlatBaseChange.tex — decompose the affine-close obligations

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex`. You edit ONLY this chapter.

## Why (strategy context)
`lem:affine_base_change_pushforward` (`affineBaseChange_pushforward_iso`, L799) is a documented partial. Its
proof sketch (L867–965) is detailed and correct, and correctly identifies (in the `% NOTE (updated iter-242)`
at L850 and the proof body) that TWO Mathlib-absent obligations remain. progress-critic ts243 (Route B
CONVERGING) and the iter-242 review handoff require: **name the two obligations as separate sub-lemma blocks
BEFORE the next prover round**, so the prover has named handles and does not reproduce the iter-242 pattern of
the blocker living unnamed inside the body. This is a decomposition pass — the existing proof prose is good;
do NOT rewrite it, EXTRACT the two obligations into their own `\begin{lemma}` blocks and have the main lemma
`\uses` them.

Also: `gammaPushforwardNatIso` (Lean `AlgebraicGeometry.gammaPushforwardNatIso`, FlatBaseChange.lean ~L664)
is a substantive supporting declaration with NO `\lean{}` block (lean-vs-blueprint fbc MAJOR). Add a pin block.

## REQUIRED EDITS

### (1) Add `lem:gammaPushforwardNatIso` pin block
Place it in the pullback-companion subsection, immediately BEFORE `lem:pullback_spec_tilde_iso` (L731).
`\lean{AlgebraicGeometry.gammaPushforwardNatIso}`, `\uses{lem:gammaPushforwardIso}`. State: the natural
isomorphism of functors `(pushforward (Spec φ)) ⋙ Γ_R ≅ Γ_{R'} ⋙ restrictScalars φ` packaging the per-object
Γ-fragment comparison `gammaPushforwardIso` (naturality in the module argument holds because every component
is the identity on underlying elements). Note its role: it is the right-adjoint natural iso that drives the
uniqueness-of-left-adjoints argument for `lem:pullback_spec_tilde_iso`. Archon-local infrastructure (no
external SOURCE QUOTE).

### (2) Add two NAMED sub-lemma blocks for the affine-close obligations
Extract from the existing `lem:affine_base_change_pushforward` proof body the two named obligations. Place
both BEFORE `lem:affine_base_change_pushforward` (or immediately after it, as a "remaining obligations"
sub-block) so they can be `\uses`-referenced. Keep the existing main proof prose; just add the named blocks
and wire `\uses`.

**Obligation 1 — `lem:base_change_map_affine_local`** (the affine reduction). State: for `f` affine and
`F` quasi-coherent, the formation of `pushforwardBaseChangeMap` (Def `def:pushforward_base_change_map`) is
COMPATIBLE with restriction to affine opens of `S'` — i.e. its restriction to each affine open `U ⊆ S'`
agrees with the base-change map of the restricted square — so that `IsIso (pushforwardBaseChangeMap …)` over
arbitrary `(S,S',X,X')` reduces (via `lem:modules_isIso_iff_affineOpens`) to the affine-affine case
`S=Spec R, S'=Spec R', X=Spec A`. Flag that this base-change-of-the-base-change-map naturality is itself
Mathlib-absent (no packaged compatibility of the abstract adjoint-mate with open restriction). SOURCE: this
is the "local on S and S'" step of Stacks `lemma-affine-base-change` (the verbatim quote is already in the
chapter at L833–849 / L805–814 — reference it; you may re-read `references/stacks-coherent.tex` if you want
the surrounding sentence, you are authorised `references/**`).

**Obligation 2 — `lem:pushforward_base_change_mate_cancelBaseChange`** (the affine-affine crux). State: in
the affine-affine case, the global-sections incarnation `Γ(α)` of `pushforwardBaseChangeMap.app U`,
transported through the two affine dictionaries (`lem:pushforward_spec_tilde_iso`, `lem:pullback_spec_tilde_iso`)
that identify its source and target with `(R'⊗_R A)⊗_A M` and `R'⊗_R M`, equals the concrete cancellation
isomorphism `TensorProduct.AlgebraTensorModule.cancelBaseChange` (`(r'⊗a)⊗m ↦ r'⊗(a·m)`). Since
`cancelBaseChange` is an iso with no flatness, this identification closes the affine case. Flag this as the
genuine crux: a coherence computation unwinding the adjoint mate of the `((g')^*,(g')_*)`-unit through the
four dictionary isos (no ready Mathlib counterpart). This is exactly the content the Mathlib `#37189` bump
(`isIso_fromTildeΓ_pushforward`) would supply.

### (3) Wire `lem:affine_base_change_pushforward`
Add `lem:base_change_map_affine_local, lem:pushforward_base_change_mate_cancelBaseChange` to its proof
`\uses{}`. Leave the existing proof prose intact (it already walks both obligations); the two new blocks just
give them named handles. Do NOT remove the existing `% NOTE (updated iter-242)` — it is accurate.

## Out of scope (do NOT touch)
- `thm:flat_base_change_pushforward` (the Čech/flatness theorem); the closed dictionary lemmas
  (`lem:pushforward_spec_tilde_iso`, `lem:pullback_spec_tilde_iso`) — do not alter their statements/proofs.
- Do NOT add/remove `\leanok` / `\mathlibok`.

## Citation discipline
The two obligation blocks derive from Stacks `lemma-affine-base-change` (Cohomology of Schemes) — its
verbatim quote already lives in the chapter (L805–814, L833–849). Reuse / reference it; if you add a new
`% SOURCE QUOTE`, read it from `references/stacks-coherent.tex` and quote character-for-character.
`gammaPushforwardNatIso` is Archon-local (no external quote).
