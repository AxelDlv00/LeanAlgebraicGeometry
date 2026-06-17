# Session 225 — review of iter-225

## Metadata
- **Iteration / session:** 225 (review of iter-225).
- **Stage:** prover (funded Decision-1 sheaf internal-hom build, sub-step 4 of 5).
- **Provers:** 1 (opus, `mathlib-build` mode), lane TS (`Picard/TensorObjSubstrate.lean`).
- **Sorry count:** project **80 → 80** (unchanged, by design — `dual` is no-sorry infra; the
  80→79 mover is sub-step 5 `exists_tensorObj_inverse`, FORBIDDEN this iter). File-local sorries
  in `TensorObjSubstrate.lean` unchanged (the L641 `isLocallyInjective_whiskerLeft_of_W` residual
  + adjacent vestigial whiskering sorries).
- **Build:** GREEN (only the deferred `CategoryTheory.Sheaf.val` → `ObjectProperty.obj`
  deprecation warnings).
- **sync_leanok:** iter 225, sha `2ca5a93c`, **added 1 / removed 0**, chapter touched
  `Picard_TensorObjSubstrate.tex` (the `lem:internal_hom_isSheaf` /
  `\lean{AlgebraicGeometry.Scheme.Modules.dual}` block — correct, the decl now exists axiom-clean).
- **blueprint-doctor:** no structural findings (no orphan chapters, no broken `\ref`/`\uses`, no
  new `axiom` declarations).

## Headline outcome — sub-step 4 RETIRED, clean 1-iter close

**The "PRIMARY closes clean; both SECONDARY items honestly blocked on the same known residual"
iter.** Sub-step 4 of the funded sheaf internal-hom build (committed iter-219; ~6–12 iter estimate;
**elapsed 7**). Prover status: **PARTIAL** mechanically (PRIMARY solved, two SECONDARY items not
landed), but the directive's own success bar — *"Retiring just PRIMARY `dual` is full sub-step-4
success"* — was **MET cleanly in one iter**, matching the progress-critic ts225 ask (a sub-step-4
PARTIAL would have pushed toward the upper bound; this is a full retirement).

## Target 1 — `AlgebraicGeometry.Scheme.Modules.dual` (SOLVED, axiom-clean)

**Goal:** the sheaf-level dual `M^∨ := ℋom_{𝒪_X}(M, 𝒪_X) ∈ SheafOfModules X.ringCatSheaf`, the
dual analogue of the in-file `Scheme.Modules.tensorObj` (L1524).

**Final form (L1558, ~4 lines):**
```lean
noncomputable def dual {X : Scheme.{u}} (M : X.Modules) : X.Modules :=
  ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
      (PresheafOfModules.dual (R₀ := X.presheaf) M.val) :
    SheafOfModules X.ringCatSheaf)
```
Sheafify the (sub-step-3, axiom-clean) presheaf dual `PresheafOfModules.dual M.val` through
`PresheafOfModules.sheafification`. The sheafification functor already lands in `SheafOfModules`, so
**no manual `Presheaf.IsSheaf` descent** was needed (file convention).

**VERIFIED FIRST-HAND this review:** `lean_verify AlgebraicGeometry.Scheme.Modules.dual` =
`{propext, Classical.choice, Quot.sound}`, `axioms_ok: true`. No `sorryAx`.

**The flagged "one real obstacle" was a NON-ISSUE.** The directive flagged the CommRingCat/RingCat
base bridge as the single real obstacle (`PresheafOfModules.dual` wants `R₀ : Dᵒᵖ ⥤ CommRingCat`
while `tensorObj` uses plain-RingCat `X.presheaf`). The prover confirmed via hover that
`X.presheaf : TopCat.Presheaf CommRingCat ↑X.toPresheafedSpace` is **already** `CommRingCat`-valued
over the single-universe site `Opens ↑X`, so `(R₀ := X.presheaf)` resolves with no re-bridging, and
`X.ringCatSheaf.val = X.presheaf ⋙ forget₂ CommRingCat RingCat` holds definitionally so
`sheafification` accepts `PresheafOfModules.dual M.val` verbatim. No `@ofPresheaf` re-derivation was
needed. (This corrects the standing plan assumption; recorded in memory `ts225-dual-object-closed`.)

## Target 2 — descended evaluation `dual_eval : M ⊗_X dual M ⟶ 𝒪_X` (BUILT, then REMOVED — sorry-transitive)

**Approach (compiled cleanly, no `sorry` token):** the exact dual analogue of how
`tensorObj_assoc_iso` closes — with `a = sheafification`, `η = sheafificationAdjunction.unit`,
`Dpre = PresheafOfModules.dual M.val`, the left-whiskered unit `M.val ◁ η.app Dpre` lies in `J.W`
(`η = toSheafify ∈ J.W`), `a.map` of it is iso (`isIso_sheafification_map_of_W`) with codomain
exactly `tensorObj M (dual M)`; compose its inverse with `a.map (internalHomEval M.val)` and the
counit `a.obj 𝟙_ ≅ 𝒪_X`.

**Why REMOVED (correct call):** `lean_verify` showed `sorryAx` in the ancestry (attempts log
events 17–18: `{propext, sorryAx, Classical.choice, Quot.sound}`). The whiskering lemma
`PresheafOfModules.W_whiskerLeft_of_W` routes through the route-(e) residual
`isLocallyInjective_whiskerLeft_of_W` (L641, an OPEN `sorry` — the **d.2 stalk-⊗ commutation gap**),
the **same** unclosed residual the associator `tensorObj_assoc_iso` is sorry-transitive through.
Per the mathlib-build invariant ("any `sorryAx` in the ancestry ⇒ not axiom-clean"), the prover
removed it rather than ship sorry-transitive output (events 19–21: re-verify after removal =
`{propext, Classical.choice, Quot.sound}`, clean). **This is the right behaviour** — the iter-214
d.1 "pin a helper-sorry" anti-pattern was avoided.

**Dead end recorded:** the flat variant `W_whiskerLeft_of_flat` is axiom-clean but needs sectionwise
flatness `∀ U, Module.Flat (𝒪_X(U)) (M.val(U))`, FALSE for line bundles over non-affine opens (the
file's iter-212 finding). No substitute. The eval cannot be defined without the whiskered-unit iso.

**Ready-to-paste:** the construction is correct and becomes a clean ~10-line axiom-clean add **the
moment `isLocallyInjective_whiskerLeft_of_W` (d.2) is closed**.

## Target 3 — `dual_isLocallyTrivial` (NOT ATTEMPTED, clean hand-off)

Needs (a) a dual-of-restriction linchpin `(dual L)|_U ≅ dual_U (L|_U)` (the internal-hom analogue
of `tensorObj_restrict_iso`, itself a multi-iter linchpin), plus (b) dual-preserves-isos and
(c) `dual_U(𝒪_U) ≅ 𝒪_U`. (a) is a substantial new build, not a 1-iter add, and likely re-routes
through the same sheafification/whiskering machinery. Deferred as a precise hand-off — correctly NOT
started under the "land axiom-clean or hand off, never pin a sorry" invariant.

## The defining strategic finding — the build now converges to ONE remaining math gap

After sub-step 4, the funnel narrows sharply: **both** the descended eval (target 2) **and** the
associator `tensorObj_assoc_iso` are sorry-transitive through the **single** open residual
`isLocallyInjective_whiskerLeft_of_W` (L641) = the **d.2 stalk-⊗ commutation**
`(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x` (Mathlib-absent at the pinned commit; per memory
`ts-module-stalk-exists`, Mathlib HAS a `PresheafOfModules` stalk and the d.1 R_x-linear stalk map
was built iter-214 — remaining = the d.1 bridge + d.2 varying-ring stalk-⊗). Sub-step 5
`exists_tensorObj_inverse` (the 80→79 mover) **consumes the descended eval**, so sub-step 5 **cannot
close until d.2 lands**. d.2 is now the true frontier of the entire ⊗-substrate lane, not a
sub-step-5 detail.

## Process correctness

- **Prover: correct, productive.** Closed the PRIMARY target axiom-clean (verified first-hand);
  probed dual_eval, caught the `sorryAx` via `lean_verify`, removed it rather than stub — the
  iter-224 lesson (probe + authoritatively verify before claiming) applied. No `maxHeartbeats`, no
  helper-sorry, no touching the 3 forbidden adjacent sorries / the `tensorObj_assoc_iso` proof / the
  vestigial whiskering decls. Did NOT undertake the deferred 14-site `Sheaf.val` deprecation
  migration (correctly out of scope).
- **No overclaim.** Task result and memory honestly state dual_eval was built-then-removed and why;
  no `\leanok`/`\mathlibok` self-attribution.

## Environment caveat (review phase)
This review's tool-output channel (Bash / Read / Glob) was intermittently unresponsive partway
through (the same LSP/Bash output-lag the iter-222 review flagged), returning empty/delayed batches —
then recovered. All headline facts were confirmed first-hand: `lean_verify` on `dual` = axiom-clean;
`dual` decl at L1580; the L641 residual sorry; the full `attempts_raw.jsonl`; the prover task result;
blueprint-doctor; the sync_leanok state. Project sorry (80, unchanged) is corroborated by the prover
report, PROGRESS.md, the iter-224 review (81→80), and the loop's meta.json. After recovery, all
review-agent actions were COMPLETED this phase (none left deferred): the `lean-vs-blueprint-checker
tensorobj225` dispatch returned 0 must-fix / 0 major / 2 minor (`dual` faithful to
`lem:internal_hom_isSheaf`); the `lem:rational_map_to_av_extends` `\lean{}`-pin correction was
applied; the dual-close Knowledge Base entry was added. See `## Review-subagent decisions` in
`iter/iter-225/review.md`.

## Key findings / patterns
- **Sheafify-the-presheaf-construction template generalises to the dual.** `dual = sheafification ∘
  PresheafOfModules.dual`, exactly mirroring `tensorObj = sheafification ∘ tensorObj_pre`. The
  CommRingCat/RingCat base "diamond" feared since iter-217 does **not** bite here because `X.presheaf`
  is already CommRingCat-valued over `Opens X`.
- **`lean_verify` ancestry-scan is the gate, not the diagnostic-message clean.** dual_eval produced
  ZERO diagnostic errors yet was sorry-transitive — only `lean_verify`'s axiom scan caught it. Always
  `lean_verify` a new mathlib-build decl before declaring it axiom-clean.
- **One residual gates two consumers.** `isLocallyInjective_whiskerLeft_of_W` (L641, d.2) blocks both
  the associator and the descended eval (hence sub-step 5). The lane's remaining cost is now
  essentially the cost of d.2.

## Recommendations for next session
See `recommendations.md`. Headline: the next sub-step (5) cannot land axiom-clean until d.2
(`isLocallyInjective_whiskerLeft_of_W`) is closed — so the plan should either pivot the lane directly
to d.2 (the stalk-⊗ commutation), or re-surface the standing RR-pause/divisor-route fork to the user,
since d.2 is the deep Mathlib-absent gap that the whole route-A ⊗-substrate now hinges on.

## Blueprint markers updated (manual)
- `AbelianVarietyRigidity.tex`, `lem:rational_map_to_av_extends`: corrected
  `\lean{AlgebraicGeometry.rationalMap_to_av_extends}` →
  `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}` (L759). The old flat name
  `rationalMap_to_av_extends` does **not** exist anywhere in the Lean source (grep-confirmed empty);
  the canonical decl is `theorem extend_to_av` in `Albanese/Thm32RationalMapExtension.lean:376`
  (namespace → `AlgebraicGeometry.Scheme.RationalMap.extend_to_av`), the pin the sibling chapter
  `Albanese_Thm32RationalMapExtension.tex` already uses. Flagged by blueprint-reviewer ts225 for the
  review agent; now reconciled. (Non-blocking — both chapters are Route-C-paused.)
- No `\leanok` touched (owned by sync_leanok, which added the `lem:internal_hom_isSheaf` /
  `\lean{...dual}` marker deterministically this iter, +1).
- No `\mathlibok` candidates (the dual is a genuine project construction, not a Mathlib re-export).
