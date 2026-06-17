# Recommendations — next plan iter (post iter-001)

## HIGH — blueprint coverage gap (lean-vs-blueprint-checker MAJOR)
- **Add a blueprint block for the restored A-bridge `homOfLocalCompat`.** Dispatch a
  blueprint-writer on `Picard_TensorObjSubstrate.tex`: add
  `\label{lem:sheafofmodules_hom_of_local_compat}` +
  `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` with a proof sketch of the two-step
  gluing (sheaf-of-types gluing of the ab-presheaf morphism via `presheafHom`/`existsUnique_gluing`,
  then `homMk` for `𝒪_X`-linearity). Also add pins for `homLocalSection`, `topSectionToHom`,
  `topSectionToHom_app` (referenced by name in prose at L4884/L5229, substantive enough to track).
  The decl exists, sorry-free, ~170 LOC — this is pure blueprint debt, not a proving task. A `% NOTE`
  was placed at `rem:dual_discharges_inverse` (~L5256) marking the gap. Correct the stale `~L5592`
  cross-ref in the `homOfLocalCompat` docstring when the block is added.

## HIGH — verify the `subsingleton` close is genuine (lean-auditor MAJOR)
- `dual_restrict_iso` isoMk naturality (DualInverse L760-762) was closed by the opaque `subsingleton`
  tactic on a **module-map** equality. The checker confirms the blueprint justifies a thin-poset /
  dual-valued Subsingleton, so this is very likely genuine — BUT the auditor notes the contradictory
  comment block (L754-757 says "cannot be discharged yet"; L760-761 says it commutes definitionally)
  and raises the possibility it fires only via sorry-contamination in `sliceDualTransport.hom`.
  - Action for the planner: have the prover that next touches this file (a) confirm the `Subsingleton`
    instance is genuine (e.g. replace with `exact Subsingleton.elim _ _` or name the instance), and
    (b) prune the stale L754-757 comment. Do NOT treat this as blocking current work — it is a
    soundness-hygiene check, not a must-fix.

## Closest-to-completion / priority targets
1. **`sliceDualTransport.toFun.naturality` (L525)** + **`sliceDualTransportInv.naturality` (L388)**
   — the keystone pair. Both reduce (via `ModuleCat.hom_ext`/`LinearMap.ext z`) to the pointwise
   ε-commutation equation. The remaining content is ONE shared technique: the ε-naturality `erw`
   paste (`PresheafOfModules.restrictScalarsLaxε` + `NatTrans.naturality` along the structure-ring
   iso). Closing L388 unblocks L525's mirror and the `left_inv`/`right_inv` round-trips (L627/629),
   which in turn finish `dual_restrict_iso` → `dual_isLocallyTrivial` → `exists_tensorObj_inverse`.
   This is the highest-leverage single technique in the project right now. Assign as a focused round
   on the ε-paste, NOT another subsingleton/hom_ext probe (those are exhausted — see below).
2. **`sliceDualTransport.left_inv`/`right_inv` (L627/629)** — defer until L388/L525 land; they need
   the `dualUnitRingSwap`/ε round-trip + `image_preimage_of_le` collapse on top of a closed
   `sliceDualTransportInv`.

## DO NOT re-assign the same approach
- **`sheafificationCompPullback_comp_tail` (TensorObjSubstrate L2623)** — do NOT send another
  fine-grain / subsingleton / hom_ext / simp-only round. The blueprint proof is already maximally
  decomposed (all 5 supporting sentences extracted + proven); the residual is an irreducible
  composite-adjunction-unit **cocycle**. Probed dead-ends this iter: `rw [leftAdjointUniqUnitEta_app]`
  (pattern absent — head is `(pullback h)`-whiskered), `simp [unit_naturality, pushforwardComp_…]`
  (all args unused). This needs the **cross-domain mate-assembly escalation** in
  `analogies/d3-mate271.md`: consume the staged `hwr` via the surjective/injective reduction of
  `leftAdjointCompNatTrans_assoc` (`CompositionIso.lean:155`), or re-prove
  `sheafificationCompPullback_comp` wholesale (Mathlib's `pullback_assoc` pattern). ~40–60 LOC. If
  the planner wants a mathlib-analogist cross-domain consult, this is the target.
- **`pullbackTensorMap_restrict` (L2851)** — gated on `comp_tail`. Do NOT assign until `comp_tail`
  lands; the body is already opened to the paste-ready 4-square form.
- **`exists_tensorObj_inverse` (L712)** — do NOT assign directly (import cycle). Closes downstream
  once the DUAL chain (`dual_isLocallyTrivial`) lands.

## MEDIUM — extraction-truncation sweep
- The DualInverse.lean truncation (entire §C tail lost mid-docstring) may not be unique. Recommend a
  one-shot check that every extracted `.lean` file terminates cleanly (no unterminated comment / no
  decl-count mismatch vs the extraction parent at
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/`). Cheap insurance against
  another silently-broken file in the downstream cone.

## MEDIUM — blueprint-doctor: broken cross-refs to dropped chapters
- `\cref` targets with no `\label` (chapters dropped in extraction): `chap:Jacobian`,
  `chap:Picard_RelativeSpec` (in `Picard_LineBundlePullback.tex`); `chap:Picard_FGAPicRepresentability`,
  `chap:Picard_RelativeSpec` (in `Picard_RelPicFunctor.tex`); `chap:Albanese_AlbaneseUP`,
  `chap:Picard_FGAPicRepresentability`, `chap:Picard_IdentityComponent` (in `Picard_TensorObjSubstrate.tex`).
  Planner: redirect to in-scope anchors or strip these dangling cross-refs (cosmetic; clutters the
  rendered dep graph).

## Coverage debt (1-to-1 Lean↔tex) — `archon dag-query unmatched` = 95 lean_aux nodes
- The plan already DEFERRED the ~91 mature parent helpers as a tracked batch (iter-001 plan.md);
  the count is now **95** — the 4 restored §C-tail decls added this session are new debt:
  `AlgebraicGeometry.Scheme.Modules.{homOfLocalCompat, homLocalSection, topSectionToHom, topSectionToHom_app}`
  (all in DualInverse.lean, sorry-free). `homOfLocalCompat`'s pin is covered by the HIGH item above;
  the other three should be pinned in the same blueprint-writer round. No frontier node currently
  depends on an unblueprinted helper (the plan's reversal signal has NOT fired), so the remaining
  batch can stay deferred until the active sorries converge.

## Reusable proof patterns discovered (→ Knowledge Base)
- `subsingleton` closes a dual-valued (maps-into-unit) isoMk naturality square over a thin poset;
  it does NOT close a restriction-of-unit-valued square (codomain not a Subsingleton) — that needs
  the ε-naturality `erw` paste. The two cases look superficially identical but differ in codomain.
- Extraction source-of-truth: when an extracted Lean file is broken/truncated, the parent repo
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/` is the last-known-good source;
  diff the byte-identical prefix, restore the lost tail.
