# blueprint-writer bw-dual263 — fix the dual sub-section of Picard_TensorObjSubstrate.tex

## Scope (STRICT)
Edit ONLY the `lem:slice_dual_transport` block (chapter `Picard_TensorObjSubstrate.tex`, lemma at
~L5674, proof at ~L5698–5746). Do NOT touch the D3′/Sq1 prose, the `lem:dual_restrict_iso` block, or
any other lemma — a review (lvb-tos262) cleared the rest of this chapter; only the dual sub-section
needs work. This is a consolidated chapter (`% archon:covers` TensorObjSubstrate.lean +
DualInverse.lean + StalkTensor + Vestigial); confine your edit to the one lemma named above.

## The gap to fix (lvb-di262 major)
The `lem:slice_dual_transport` proof's "Inverse, linearity, and naturality" paragraph (~L5737–5745)
is too thin on the linearity step. A prover following the blueprint alone hits a wall it does not
warn about: the `\(\mathcal{O}_Y(V)\)`-module additive/scalar structure on the LEFT-hand value
(`((pushforward β).obj (dual M.val))(V)`) is the module action coming from
`PresheafOfModules.InternalHom.internalHomObjModule` (\cref already exists at `lem` defining
`internalHomObjModule`, ~L5187), and this `+`/`•` is NOT syntactically the
`PresheafOfModules.Hom` add/scalar action. So the naive "linearity = post-composition compatibility"
step cannot fire directly — the equivalence's `map_add'`/`map_smul'` obligations require FIRST
unfolding/identifying the `internalHomObjModule` add (resp. smul) field with the underlying
`PresheafOfModules.Hom` add (resp. smul) before the change-of-rings compatibility applies.

## What to add (mathematical prose only — no Lean tactics, no `\leanok`)
Expand the "Inverse, linearity, and naturality" paragraph so it explicitly records, as a distinct
mathematical step BEFORE the change-of-rings compatibility:

> The additive and scalar structure on a dual section of the left-hand value is the module structure
> carried by `internalHomObjModule` (\cref{lem:...internalHomObjModule}) — the pointwise module
> structure on the internal-hom object — which agrees with, but is a priori a distinct presentation
> of, the additive/scalar structure of the underlying presheaf morphism. The verification of additivity
> and \(\mathcal{O}_Y(V)\)-linearity of the transport therefore proceeds in two steps: (i) identify the
> `internalHomObjModule` add and scalar actions with the underlying morphism-level (pointwise) add and
> scalar actions — a definitional identification of the two module presentations; (ii) on the underlying
> morphism level, additivity and linearity follow from the post-composition compatibility of the
> change-of-rings reindexing (functoriality of `restrictScalars β_W` on sums and scalar multiples) and
> the structure-scalar intertwining of the ring iso — the presheaf-level shadow of
> \cref{lem:restrictscalars_ringiso_dualequiv}.

Keep it mathematical and at textbook level; state the two-step structure clearly so the prover knows
the `internalHomObjModule`↦morphism-level identification is a required first move, not an afterthought.

## Also (lvb-di262 minor)
The two leg-B sub-claims are now realised as named Lean decls in DualInverse.lean. If the chapter has
natural anchor sentences for them, add inline `\lean{}` hints:
- leg-B unit ε-iso: `\lean{AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso}`
- leg-B codomain swap: `\lean{AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap}`
Place them on the sentences in the leg-B paragraph that describe those constructions (the `ε` is an
iso sentence; the `codomainMap := inv ε` sentence). Verify the exact namespace by checking the decl in
`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` before adding — only add a `\lean{}`
hint if the decl name matches what is in the file. If you cannot confirm the exact name, omit the hint
(do not guess).

## Out of scope
- No `\leanok`/`\mathlibok` markers (deterministic phases own them).
- No edits outside `lem:slice_dual_transport`.
- No new `% SOURCE` quotes needed (this is project-bespoke construction prose; the existing Stacks
  citation on the sibling `lem:dual_restrict_iso` stays put).
