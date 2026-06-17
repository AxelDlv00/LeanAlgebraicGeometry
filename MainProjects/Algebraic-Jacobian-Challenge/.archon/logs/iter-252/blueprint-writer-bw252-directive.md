# blueprint-writer bw252 — directive

Chapter to edit: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (ONLY this chapter).

Three math-content updates. All are MATHEMATICAL prose — do NOT write Lean tactics, Lean term
syntax, or `\leanok`/`\mathlibok` markers. Keep the project's notation.

## 1. Add a tracked block for `dual_unit_iso` (currently named-but-untracked)

In the proof of `lem:dual_isLocallyTrivial` (~L5486–5540), Step 3 names the isomorphism
`dual 𝒪_U ≅ 𝒪_U` informally ("dual_unit_iso") but there is no `\lean{}`-pinned block for it, so the
dependency graph cannot track it. The declaration `AlgebraicGeometry.Scheme.Modules.dual_unit_iso`
exists and is closed in Lean. Promote it to a named lemma block:

- `\begin{lemma}[Dual of the structure sheaf]` `\label{lem:dual_unit_iso}`
  `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}`
  `\uses{...}` (cite the internal-hom evaluation lemma and the presheaf left-unitor it rests on —
  whatever the existing Step-3 prose already references).
- Statement: the sheaf-level dual of the structure sheaf is canonically the structure sheaf,
  `dual (𝒪_Y) ≅ 𝒪_Y`, obtained by sheafifying the presheaf-level "evaluation at 1" isomorphism
  `ℋom(𝟙, 𝟙) ≅ 𝟙` (every unit-endomorphism is multiplication by its value at the global section 1).
- Then update the Step-3 reference in `lem:dual_isLocallyTrivial`'s proof to `\cref{lem:dual_unit_iso}`,
  and remove the stale `% NOTE: (review iter-251 ...) dual_unit_iso is named here but ...` comment at
  ~L5536 (it is now resolved).

## 2. Correct + deepen the Step-4 proof of `lem:dual_restrict_iso` (~L5386–5470)

The current proof sketch under-specifies the final step. A mathlib-analogist consult
(`analogies/dual252.md`) established the correct mathematical structure: **the dual is NOT sectionwise**
(unlike the tensor product). For an open `U`, `(dual M)(U)` is a Hom of presheaves over the whole
down-set `Over U` (`ℋom(M, 𝟙)` restricted to `Over U`), not a single fiber `M(U) →ₗ 𝒪(U)`. Therefore
"restriction along the open immersion `f : Y → X` commutes with the dual" does NOT reduce to a single
ground-ring reconciliation; it factors into TWO legs:

- **Leg (A) — slice-site Hom base-change (Beck–Chevalley).** Transport the domain presheaf:
  `restr_V (f_* M)` over the down-set `Over V ⊆ Opens Y` is carried to `restr_{fV} M` over
  `Over fV ⊆ Opens X` across the fully faithful open-immersion functor `f` on the down-set of `fV`.
  This is a genuine slice-site equivalence on the Hom, not a fiberwise identity.
- **Leg (B) — ground-ring reconciliation.** The unit codomain is reconciled along the open-immersion
  ring isomorphism `𝒪_X(fV) ≅ 𝒪_Y(V)`; this is the content of the (closed) ingredient
  `InternalHom.restrictScalarsRingIsoDualEquiv` (the dual analogue, at the module level, of the
  ring-iso tensor equivalence that closed the tensor lane's H2 step).

The Step-4 isomorphism is the sectionwise composite (A) ≪ (B), packaged over the slice with
poset-thin naturality. Rewrite Step 4 to describe this (A)+(B) decomposition explicitly. Add a
sentence noting WHY the tensor lane's H2 step (`restrictScalarsMonoidalOfBijective`) has no direct
dual analogue here: the tensor product is sectionwise so its transport collapsed to leg (B) alone,
whereas the dual's non-sectionwise nature forces the additional leg (A).

Add a short `% NOTE`-style cautionary sentence in the prose (visible text, not a `%` comment) that the
naive "fixed-value-category slice equivalence" (the Sheaf-level `overSliceSheafEquiv`) is **not**
applicable to leg (A), because this residual lives at the presheaf level with a varying per-section
ring `𝒪_Y(V)` and finer slicing.

Optionally record the alternative route flagged by the consult (do not commit to it): `dual_restrict_iso`
may also be derivable from the already-closed `tensorObj_restrict_iso` by uniqueness of monoidal
inverses (the dual is the ⊗-inverse), via evaluation/coevaluation naturality — a candidate if the
inverse-uniqueness glue proves cheaper than building leg (A).

## 3. One math-level sentence in the proof of `lem:pullback_tensor_map_natural` (D1′, ~L3300–3345)

The proof currently describes the 4-square paste. Add ONE sentence (math only) clarifying that the
fourth square — the naturality of `sheafifyTensorUnitIso` — reduces, after expanding the comparison
into its whisker factors, to the **naturality of the sheafification unit** `η` (i.e.
`p ≫ η = η ≫ (sheafification.map p)` in each tensor argument), the middle crossings being handled by
the monoidal interchange (whisker-exchange) law. Do NOT describe the Lean instance-elaboration idiom
(that is tracked in `analogies/whisker252.md`, not blueprint material). There is a `% NOTE` at
~L3337–3343 requesting this; replace it with the one math sentence and drop the NOTE.

## Out of scope
- Do NOT touch any other chapter.
- Do NOT add/remove `\leanok` or `\mathlibok`.
- Do NOT add Lean tactic sequences anywhere.
- Do NOT alter the off-path `% NOTE: ABANDONED` blocks (`lem:pullback_tensor_iso`, `lem:pullback0_tensor_iso`).
