# Blueprint-writer directive — `Picard_TensorObjSubstrate.tex` (associator reroute to the d.2 stalk-tensor; iter-233)

You are updating ONE chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.
Strategy context: the relative-Picard group `Pic X` is carried on tensor-invertibility
`IsInvertible M := ∃N, M⊗N≅𝒪` (inverse = free membership witness). The group law
`thm:pic_commgroup` needs the associativity isomorphism for `tensorObj`. The current
associator proof is mathematically BROKEN and must be rerouted. Four tasks:

## Task 1 (MUST-FIX — stale labels flagged by blueprint review)
Two passages are stale and contradict the live proof graph:
- The "Superseded route --- off path, not to be formalized" paragraph that precedes
  `lem:flat_whisker_localizer` says the block "must not be formalized." This is FALSE:
  `lem:flat_whisker_localizer` IS formalized and sorry-free in Lean. Remove/replace
  the "must not be formalized" instruction for the `flat_whisker_localizer` entry.
  (The identical paragraph before `lem:whisker_of_W` is CORRECT — leave that one.)
- The internal-consistency section (§ `sec:tensorobj_consistency_check`) states
  `lem:flat_whisker_localizer` "is superseded on the critical path by the flatness-free
  `_of_W` variants." After this reroute that becomes doubly stale (see Task 2 — the
  flat route is abandoned). Rewrite that sentence to reflect Task 2's outcome:
  neither the flat-whiskering NOR the flatness-free `_of_W` whiskering is on the
  critical path any longer; the associator is realized unconditionally via the d.2
  stalk-tensor commutation (Task 3).

## Task 2 (CORE — reroute the associator; the current proof is WRONG)
The proof of `lem:tensorobj_assoc_iso_invertible` (and the framing of
`lem:tensorobj_assoc_iso`) currently argues: "invertible ⟹ locally free of rank 1 ⟹
each section `M(U)` is flat over `𝒪_X(U)`, so feed the flat-whiskering lemma
`lem:flat_whisker_localizer`." THIS STEP IS FALSE. Local-freeness (local triviality)
does NOT give GLOBAL sectionwise flatness: `M(U)` over `𝒪_X(U)` is not flat for a
non-affine open `U` (the project's own iter-212 finding; a global-sections Tor₁
obstruction). A Mathlib-API review (`analogies/monoidal-transport.md`) confirms
`_of_flat` cannot be fed for a line bundle globally, and that the proposed
"Mathlib monoidal-sheafification" shortcut does not exist (`Sites.Point.IsMonoidalW`
is not in Mathlib; `Sheaf.monoidalCategory` is for a fixed value category, not
`SheafOfModules` over a varying ring).

**Reroute:** make the GENERAL associator `lem:tensorobj_assoc_iso` UNCONDITIONAL,
realized through the d.2 stalk-tensor commutation (Task 3) which closes the single open
whiskering obligation `lem:islocallyinjective_whisker_of_W`
(`isLocallyInjective_whiskerLeft_of_W`) for ALL modules — no flatness, no local
triviality. Then:
- Rewrite the proof of `lem:tensorobj_assoc_iso` so it `\uses` the new d.2 lemma
  (Task 3, `lem:islocallyinjective_whiskerleft_via_stalk`) instead of the flat or the
  open `_of_W` route. State plainly: the presheaf-level associator
  `PresheafOfModules.monoidalCategoryStruct.associator` exists for all modules; the
  sheafification transport needs `F ◁ toSheafify ∈ J.W`, which d.2 supplies stalkwise.
- Demote `lem:tensorobj_assoc_iso_invertible` to a one-line COROLLARY of the now-
  unconditional `lem:tensorobj_assoc_iso` (just specialize to invertible `M,N,P`).
  DELETE the false "invertible ⟹ flat ⟹ sectionwise flat" argument and the Stacks-0B8M
  flatness framing from its proof. Update its `\uses` to
  `{lem:tensorobj_assoc_iso}` (drop `lem:flat_whisker_localizer`).
- `thm:pic_commgroup`'s `mul_assoc` now consumes the unconditional associator's
  EXISTENCE — keep that framing.

## Task 3 (NEW d.2 section + new file coverage)
Add a new section to this chapter for the **varying-ring stalk-tensor commutation**
(the genuine remaining Mathlib gap, ~200-400 LOC, to be built in a NEW Lean file
`AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`). Extend the chapter's
`% archon:covers` line to also list
`AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`.

New blocks (give rigorous, formalizable proof sketches):
1. `\lemma \label{lem:stalk_tensor_commutation}`
   `\lean{PresheafOfModules.stalkTensorIso}` [expected name; mark prose, not a command].
   Statement: for `R : (Opens X)ᵒᵖ ⥤ CommRingCat`, presheaves of modules
   `A B : PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat)`, and a point `x : X`,
   there is a natural isomorphism of `(R ⋙ forget₂).stalk x`-modules
   `(A ⊗ᵖ B).stalk x ≅ A.stalk x ⊗_{R.stalk x} B.stalk x`, where `⊗ᵖ` is
   `PresheafOfModules.Monoidal.tensorObj`. Proof sketch: the stalk is the filtered
   colimit over neighbourhoods `U ∋ x`; sectionwise `(A⊗ᵖB)(U) = A(U) ⊗_{R(U)} B(U)`
   (`PresheafOfModules.Monoidal.tensorObj_obj`); tensor product commutes with filtered
   colimits and the base ring `R(U)` also colimits to the stalk ring `R.stalk x`, so
   `colim_U (A(U) ⊗_{R(U)} B(U)) ≅ (colim_U A(U)) ⊗_{colim_U R(U)} (colim_U B(U))`.
   The project already has the `R_x`-linear stalk map (`stalkLinearMap`, "d.1"); this
   is the "d.2" upgrade to a tensor-commutation iso. RETRIEVE and cite the source for
   "stalk of a tensor product of sheaves of modules is the tensor of stalks over the
   stalk ring" — Stacks Project (Modules on Ringed Spaces, the tensor-product section;
   the relevant tag states `(F ⊗_{O_X} G)_x = F_x ⊗_{O_{X,x}} G_x`) — read the actual
   Stacks file under references/ and quote verbatim per citation discipline.
2. `\lemma \label{lem:islocallyinjective_whiskerleft_via_stalk}`
   `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` (this is the EXISTING
   open obligation; the new proof closes it). Statement (unchanged): for a `J.W`
   (locally-bijective) morphism `g : M ⟶ N` and any `F`, the left-whisker `F ◁ g` is
   locally injective. Proof sketch via d.2: a `J.W` morphism is a stalkwise iso
   (d.1 packaging, `WEqualsLocallyBijective` + `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso`);
   by `lem:stalk_tensor_commutation`, `(F ◁ g)_x ≅ id_{F_x} ⊗ g_x`, an iso (functors
   preserve isos); so `F ◁ g` is a stalkwise iso, hence in `J.W`, hence locally
   injective (`GrothendieckTopology.W.isLocallyInjective`). No flatness, no local
   triviality.
Wire the existing `lem:tensorobj_assoc_iso` proof to `\uses
{lem:islocallyinjective_whiskerleft_via_stalk}`.

## Task 4 (annotation — soft must-fix)
On `thm:rel_pic_addcommgroup_via_tensorobj`, add a one-line prose note that its `\uses`
of the old locally-trivial group law `lem:tensorobj_isoclass_commgroup` is DEFERRED and
will repoint to `thm:pic_commgroup` when the carrier group lands. (Do not change the
`\uses` itself this iter.)

## Constraints
- Math prose only; NO Lean tactics; NO `\leanok`/`\mathlibok` markers (managed by sync).
- Citation discipline: every external claim needs `% SOURCE:` + verbatim `% SOURCE QUOTE:`
  + visible `\textit{Source: ...}`, quoting a file you actually open under references/.
  You are authorized to spawn a reference-retriever (write-domain includes references/**)
  if the Stacks stalk-of-tensor tag is not already local.
- Keep the demoted-dual-bridge content as-is (off critical path); do not resurrect it.
