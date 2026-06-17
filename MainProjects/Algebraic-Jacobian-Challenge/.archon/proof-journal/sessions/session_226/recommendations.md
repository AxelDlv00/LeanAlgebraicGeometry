# Recommendations for the iter-227 plan agent

## Headline

iter-226 landed the **B-connector** (`isIso_of_isIso_restrict`) axiom-clean — the cheapest of the
three d.2-free descent bridges. The 80→79 mover `exists_tensorObj_inverse` is **still blocked on two
bridges**. Project sorry has had no genuine downward move since iter-217; the route is forward but the
counter only moves when A **and** C land. No must-fix-this-iter findings from either review subagent.

## Closest-to-completion / next prover targets (priority order)

1. **Bridge A — SheafOfModules morphism descent (attempt first; cheaper, bounded).** Glue the canonical
   local trivialising isos `(L ⊗ dual L)|_{Uᵢ} ≅ 𝒪_{Uᵢ}` (pattern of `tensorObj_isLocallyTrivial`,
   `TensorObjSubstrate.lean:1912`) — agreeing on overlaps (a **bounded cocycle check, NOT d.2**) — into a
   global `tensorObj L (dual L) ⟶ 𝒪_X` via `CategoryTheory.Presheaf.IsSheaf.hom` / `sheafHomSectionsEquiv`
   (`Sites/SheafHom.lean:207,241`) + `PresheafOfModules.homMk` (`Presheaf.lean:200`). Then the landed
   `isIso_of_isIso_restrict` upgrades the glued morphism to a global iso. Prover estimate ~30–60 LOC.
2. **Bridge C — `dual_isLocallyTrivial` (budget as a multi-iter MIRROR build).** `IsLocallyTrivial L →
   IsLocallyTrivial (dual L)`. Crux is `(dual M).restrict f ≅ dual (M.restrict f)` for an open immersion
   `f` — the dual analogue of the CLOSED `tensorObj_restrict_iso` (`:1822`). The prover itself calls this
   a **"major mirror build"**: the hard presheaf step needs `restrictScalars` along the open-immersion
   ring iso to commute with the bespoke presheaf `dual` (= `internalHom(-, R)`), carried via
   `ModuleCat.restrictScalarsEquivalenceOfRingEquiv` (`ChangeOfRings.lean:285/325/335`). Plus (C2)
   `dual (𝒪_U) ≅ 𝒪_U` at sheaf level. Do **not** under-budget this; it mirrors an already-hard lemma.

## ⚠️ Pre-named reversal signal — honour it

The iter-226 plan committed: **if bridge A or C silently re-requires a stalk / filtered-colimit-⊗
statement** (i.e. the d.2 commutation `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x`), then the analogist's "route is
d.2-free" verdict (ts226descent, verdict D) was wrong in practice, and the route reverts to the forced
fork — at which point the **RR-pause / divisor-`Pic⁰` escalation becomes the live USER decision**. When
dispatching the bridge-C prover, instruct it to probe the presheaf step for a tensor-stalk dependency
**early** and report immediately if one surfaces, rather than burning the iter.

## Process guidance — do NOT retry without structural change

- The B-connector approach is **closed**; do not re-dispatch it. The reusable stalkwise pattern is in
  `PROJECT_STATUS.md` Knowledge Base.
- This is the route's continued no-downward-move streak. If iter-227 lands yet another *helper* without
  moving the sorry counter, the progress-critic's STUCK verdict hardens — the next plan must treat that
  as the trigger to either commit to closing `exists_tensorObj_inverse` end-to-end or escalate. Re-running
  another exploratory consult would be churn.

## Review-subagent findings to action (NONE blocking; all plan/prover ride-along scope)

**lean-auditor ts226** (`task_results/lean-auditor-ts226.md`; 0 must-fix, 2 major, 1 minor):
- **MAJOR — stale `.lean` docstring, prover ride-along.** `exists_tensorObj_inverse` docstring (L1987–2003,
  the "iter-218 INCOMPLETE gate" block) is now **factually false** and **contradicts its own body comment**:
  it claims "`Linv` cannot even be named" (false since iter-225 — `dual L` is nameable) and "we do NOT push
  a `dual`-shaped helper-sorry forward" (the iter-226 body now exploits `dual`). Fold a docstring rewrite
  into the next prover's ride-along for this file.
- **MAJOR — stale file header.** Header (L69–73) lists `AlgebraicGeometry.Scheme.Modules.monoidalCategory`
  as blueprint-pinned declaration #3; that declaration **does not exist** (§2 L1587–1597 records its
  removal). Prover ride-along: drop it from the header index.
- **MINOR.** L2002 cross-reference "at L1349" is stale (`tensorObj_isLocallyTrivial` is at L1912).
- The B-connector statement + proof were independently confirmed well-formed, non-vacuous, no dead-ends.

**lean-vs-blueprint-checker ts226** (`task_results/lean-vs-blueprint-checker-ts226.md`; 0 must-fix, 3 major,
2 minor) — all **plan-agent / blueprint-writer** actions:
- **MAJOR — add a blueprint block for the B-connector.** `isIso_of_isIso_restrict` is substantive
  axiom-clean infrastructure with **no `\lean{}` pin** in any chapter, so `sync_leanok` cannot track it.
  Add a named block in `sec:tensorobj_dual_infra` (suggested label `lem:isiso_of_isiso_restrict`).
- **MAJOR — `Picard_TensorObjSubstrate.tex` lacks `% archon:covers AlgebraicJacobian/Picard/TensorObjSubstrate.lean`.**
  No chapter declares coverage of this file; add the annotation near the chapter top (the HARD-GATE
  file→chapter mapping relies on it). The chapter was identified only via the Lean file's own header.
- **MAJOR — A-bridge under-specified in the blueprint.** The descent step is only an inline remark in
  `rem:dual_discharges_inverse`; promote it to a named block (e.g. `lem:sheafofmodules_hom_of_local_compat`)
  so the A-bridge prover work is trackable. (C-bridge IS named with an adequate sketch in `sec:tensorobj_dual_infra`,
  lines ~2732–2773 — A is the gap.)
- **MINOR.** `lem:tensorobj_unit_iso` lacks `\leanok` despite sorry-free Lean decls (a `sync_leanok` gap —
  not an agent action; flag if it persists next sync). `lem:internal_hom_isSheaf` pin/prose mismatch
  (block title broader than the single `dual` pin).

> Plan-agent note: the three blueprint-writer actions above are the right way to clear the HARD GATE
> *before* dispatching the A-bridge prover — add the `archon:covers` annotation and the two named blocks
> (B-connector + A-bridge) this iter, then the A-bridge file→chapter mapping is well-formed.

## Reusable proof pattern discovered

- **Locally-iso ⇒ global iso for `X.Modules` morphisms via the stalkwise criterion** — full recipe +
  three API gotchas (`Ab.{u}` explicit universe; `Functor.map_isIso` not an instance through a triple
  composite, use `dsimp only [Functor.comp_map]; exact Functor.map_isIso _ _`; `TopCat.Sheaf` hom field
  is `.hom`) recorded in `PROJECT_STATUS.md` → Knowledge Base → Proof patterns.
