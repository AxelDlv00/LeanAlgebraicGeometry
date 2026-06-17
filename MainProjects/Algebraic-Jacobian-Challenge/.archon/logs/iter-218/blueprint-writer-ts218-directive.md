# Blueprint-writer directive — chapter `Picard_TensorObjSubstrate.tex` (slug ts218)

You edit exactly ONE file: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.
(`references/**` is in your write-domain only so you may spawn a reference-retriever
if you genuinely need a source you lack — you almost certainly will not here.)

## Strategy context (only the slice that matters)

This chapter is the A.1.c.SubT ⊗-substrate. iter-217 CLOSED the linchpin
`tensorObj_restrict_iso` (the restriction-compatibility iso of the substrate tensor,
axiom-clean, via the H1 presheaf pushforward adjunction + H2 strong-monoidal
`restrictScalars`). With that closed, the project is now:
(a) **re-routing** the associator `tensorObj_assoc_iso` OFF the old "whiskering"
apparatus and ONTO `tensorObj_restrict_iso`, and then **deleting** the now-dead
whiskering/stalk apparatus (the old route-(d)/(e) monoidal-localizer machinery);
(b) building `exists_tensorObj_inverse` (the ⊗-dual of a line bundle).

Your job is to bring the chapter into line with that state so a prover can formalize
against it without hitting a corrupted dependency graph or stale prose.

## Tasks (in priority order)

### 1. MUST-FIX — repair two malformed `\uses{...}` blocks (corrupted dependency graph)

`sync_leanok` mis-inserted a `\leanok` token INSIDE two multi-line `\uses{...}`
arguments. A `\uses{...}` argument must contain ONLY a comma-separated list of
labels — no `\leanok`, no other macros, inside the braces. Reflow each so the braces
contain only labels.

- **Proof block of `lem:tensorobj_assoc_iso`** (~tex L1376–1379). Currently:
  ```
  \uses{def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso,
  \leanok
        lem:whisker_of_W, lem:islocallyinjective_whisker_of_W}
  ```
  Because the associator is being **re-routed onto `tensorobj_restrict_iso`** and the
  whiskering apparatus is being **deleted** (Task 3), the corrected `\uses` for this
  proof must drop the whiskering labels entirely:
  ```
  \uses{def:scheme_modules_tensorobj, lem:tensorobj_restrict_iso}
  ```
  No `\leanok` inside the braces.

- **Proof block of `thm:rel_pic_addcommgroup_via_tensorobj`** (~tex L2043–2050). Currently
  the first `\uses` line has a `\leanok` after the first comma. Reflow to a single
  well-formed list with ONLY labels inside the braces (keep all the existing labels:
  `lem:tensorobj_lift_onproduct, lem:pullback_compatible_with_tensorobj,
  def:scheme_modules_isinvertible, lem:tensorobj_isoclass_commgroup,
  thm:relative_pic_quotient_well_defined, lem:rel_pic_sharp_groupoid`). The proof body
  is a `sorry`, so there must be NO proof-level `\leanok` anywhere for this block.

Do NOT add any new `\leanok` or `\mathlibok` anywhere. (If a `\leanok` currently sits
inside `\uses{}` braces, that is malformed — the reflow simply leaves it out; you are
fixing LaTeX well-formedness, not managing markers.)

### 2. MUST-FIX (major) — pin the 5 new iter-217 presheaf-level helpers

These declarations were added in iter-217 (axiom-clean, the H1/H2 substrate of
`tensorObj_restrict_iso`) and have NO `\lean{...}` pin in the chapter. Add a single new
`\begin{lemma}` block (place it immediately before or after the
`lem:tensorobj_restrict_iso` block, whichever reads better) titled e.g. "Presheaf-level
pushforward adjunction and strong-monoidal restriction (H1/H2 substrate)", with:
```
\lean{PresheafOfModules.pushforwardNatTrans,
      PresheafOfModules.pushforwardCongr,
      PresheafOfModules.pushforwardPushforwardAdj,
      PresheafOfModules.isIso_of_isIso_app,
      PresheafOfModules.restrictScalarsMonoidalOfBijective}
\uses{def:scheme_modules_tensorobj}
```
and a short prose paragraph explaining: `pushforwardNatTrans` / `pushforwardCongr` /
`pushforwardPushforwardAdj` are the presheaf-level de-sheafifications of Mathlib's
sheaf-level `SheafOfModules.pushforward{NatTrans,Congr,PushforwardAdj}`
(`Mathlib/Algebra/Category/ModuleCat/Sheaf/PushforwardContinuous.lean`); via
`Adjunction.leftAdjointUniq` against the existing
`PresheafOfModules.pullbackPushforwardAdjunction` they give `pushforward β ≅ pullback φ`
(H1). `restrictScalarsMonoidalOfBijective` (built from `isIso_of_isIso_app`) is the
presheaf-level strong-monoidal structure on `restrictScalars` for a sectionwise-bijective
base change (H2). These are the two Mathlib-absent ingredients the linchpin needed; they
are upstream-PR candidates. Disambiguate `restrictScalarsMonoidalOfBijective` (presheaf,
bijective form) from `restrictScalarsMonoidalOfRingEquiv` (module level, ring-equiv form,
already pinned in `lem:restrictscalars_ringiso_strongmonoidal`). Do NOT add `\leanok`.

### 3. Promote the associator RE-ROUTE to the realized proof; mark the whiskering/stalk apparatus SUPERSEDED and remove its `\lean{}` pins

The proof block of `lem:tensorobj_assoc_iso` currently describes a "Current realization
(via whiskering)" paragraph and a "Planned re-route (target; not yet realized)"
paragraph. The whiskering route is being deleted. Rewrite the proof so the **re-route is
THE proof**: glue the canonical local isomorphisms
`((M⊗N)⊗P)|_U ≅ (M|_U ⊗ N|_U)⊗ P|_U ≅ M|_U ⊗ (N|_U ⊗ P|_U) ≅ (M⊗(N⊗P))|_U` over a
common open cover, the first/third arrows being `tensorObj_restrict_iso` applied twice,
the middle arrow the canonical presheaf-level associator, and the global iso obtained by
gluing because "Hom is a sheaf" (the local isos agree on overlaps by naturality of
`tensorObj_restrict_iso`). Keep the note that the group law consumes only the existence
of this iso (no pentagon/triangle/naturality). Delete the "Current realization via
whiskering" paragraph. The `\uses` is `{def:scheme_modules_tensorobj,
lem:tensorobj_restrict_iso}` (already set in Task 1).

The following declarations are being **REMOVED from the Lean file in iter-218** (they
were the old route-(d)/(e) monoidal-localizer + stalk machinery, made dead by the
associator re-route). For EACH corresponding blueprint block, (i) REMOVE its `\lean{...}`
pin so no pin dangles after the Lean decls are deleted, and (ii) keep the lemma statement
as prose but prepend a one-line note "% SUPERSEDED route (route-(d)/(e) whiskering/stalk
machinery); Lean declaration removed in iter-218 after the associator re-route onto
`tensorobj_restrict_iso`.". Do NOT delete the prose blocks entirely (they record the
historical route); just unpin them.

  - `lem:islocallyinjective_whisker_of_W`  (`PresheafOfModules.isLocallyInjective_whiskerLeft_of_W`)
  - `lem:whisker_of_W`  (`PresheafOfModules.W_whiskerLeft_of_W, W_whiskerRight_of_W`)
  - `lem:flat_whisker_localizer`  (`PresheafOfModules.W_whiskerLeft_of_flat, W_whiskerRight_of_flat`)
  - `lem:isiso_sheafification_map_of_W`  (`PresheafOfModules.isIso_sheafification_map_of_W`)
  - `lem:stalk_linear_map`  (`PresheafOfModules.stalkLinearMap, stalkLinearMap_germ, stalkLinearMap_bijective_of_isIso, stalkLinearEquivOfIsIso`)
  - `lem:jw_ismonoidal`  (if such a block exists, e.g. `\lean{...W.IsMonoidal...}`) — unpin + mark superseded.

This also resolves the prose/pin inconsistency the iter-217 review flagged on
`lem:islocallyinjective_whisker_of_W` (prose said "being removed" but pin remained).

Any `\cref{}`/`\uses{}` elsewhere that pointed at these now-unpinned labels: leave the
labels intact (the blocks still exist as prose with their `\label{}`), so cross-refs do
not break.

### 4. Verify the `exists_tensorObj_inverse` proof prose is formalization-ready

Check the proof block of `lem:tensorobj_inverse_invertible`
(`AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse`). A prover will formalize it
this iter. Ensure the sketch is rigorous and complete: the inverse is the dual
`L⁻¹ := \mathcal{Hom}_{\mathcal O_X}(L, \mathcal O_X)`; on a trivialising open cover where
`L|_U ≅ \mathcal O_U`, the evaluation/contraction map `L ⊗ L⁻¹ → \mathcal O_X` is a local
isomorphism (locally it is `\mathcal O_U ⊗ \mathcal O_U ≅ \mathcal O_U`); `L⁻¹` is locally
trivial; gluing the local contraction isos (they agree on overlaps) gives the global iso
`tensorObj L L⁻¹ ≅ unit`. If the existing prose is thinner than this, enrich it to this
level of detail (cite the project's `tensorObj_restrict_iso`, `tensorObj_unit_iso`, and
`LineBundle.IsLocallyTrivial`). If it is already adequate, leave it. Do NOT add `\leanok`.

### 5. Light prose hygiene
If the module-level intro prose or any block still asserts the chapter is a "file-skeleton
scaffold with 4 sorry-bodied declarations" (an iter-202 statement), correct it to reflect
that `tensorObj`, `tensorObj_functoriality`, the unitors, braiding, and
`tensorObj_restrict_iso` are all CLOSED. Keep it terse.

## Out of scope
- Do NOT touch any `\leanok` / `\mathlibok` markers (add or remove standalone ones).
- Do NOT edit any other chapter.
- Do NOT add proof tactics or Lean syntax to the prose.
- Do NOT invent new references; the H1/H2 Mathlib citations above are sufficient and
  already in the chapter's existing source comments.

## Report
In your task_results report, list: each edit made (by label), confirm the two `\uses`
blocks now contain only labels, confirm the 5 new pins were added, list which blocks were
unpinned+marked-superseded, and note any "Strategy-modifying findings" (there should be
none — if you find the inverse construction is mathematically unsound, STOP and say so).
