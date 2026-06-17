# Session 230 — review summary

- **Session / iter:** 230. **Project sorry: 80 → 80** (canonical `meta.json`).
- **TensorObjSubstrate.lean file-local sorry: 3 → 3** — L659
  (`isLocallyInjective_whiskerLeft_of_W`), L2188 (`exists_tensorObj_inverse`), L2253
  (`addCommGroup_via_tensorObj`), verified via `lake env lean` sorry warnings.
- **Target attempted:** the C-bridge `dual_restrict_iso` as a binding probe of whether the
  iter-229 shared root `overSliceSheafEquiv` closes a consumer of `exists_tensorObj_inverse`.

## Headline

The **binding-probe iter**. iter-229 funded the shared root on the thesis "both ⊗-inverse
bridges (A `homOfLocalCompat`, C `dual_isLocallyTrivial`) reduce to it." iter-230 tested the C
half in Lean for the first time. **Verdict: DOES NOT CLOSE.** The pre-committed escalation
tripwire (wired iter-227, reaffirmed 228/229/230) **fires** → the route is escalated to the
USER.

## What was attempted (from attempts_raw.jsonl)

One prover (opus, mode `prove`), 3 edits / 1 goal-check / 3 diagnostics. It mirrored the
closed `tensorObj_restrict_iso` for `dual` via a SCRATCH def, then probed the residual:

1. **SCRATCH `dual_restrict_iso_SCRATCH`** (Steps 1–3 + H1: `restrictFunctorIsoPullback`,
   `sheafificationCompPullback`, strip sheafification, `leftAdjointUniq`). → Steps typecheck;
   residual `(pushforward β).obj M.val.dual ≅ (M.restrict f).val.dual` remains open.
2. **`change`** to the symmetric form `… ≅ ((pushforward β).obj M.val).dual`. → confirms the
   residual = "pushforward commutes with the presheaf dual".
3. **`exact (overSliceSheafEquiv (X:=Y) (U:=⊤) AddCommGrp).functor.mapIso (Iso.refl _)`** →
   **`Unknown constant overSliceSheafEquiv`** (defined later, L2366) **+ type incompatibility**
   (sheaf-level functor vs presheaf-level residual). DECISIVE failure.
4. **`have h : (SheafOfModules.unit …).val = 𝟙_ … := rfl`** (unit-iso variant) → routes
   through the same `Over`-slice machinery; not closable here.

The prover folded the scaffolding into a `/-! … -/` diagnostic comment block (no committed
decl, no sorry), wrote `informal/dual_restrict_iso.md`, and confirmed build GREEN.

## Root cause (three independent reasons the root can't close C)

1. **Sheaf vs presheaf** — root is `Sheaf≌Sheaf`; residual is presheaf-level (Step 3 stripped
   sheafification); root not in scope at the site.
2. **Fixed-value-cat vs varying-ring module** — root parametric in a fixed `A`; residual is
   `ModuleCat` over the varying `𝒪_Y(V)`; the per-`V` `internalHomObjModule` action is not
   transported by a value-cat-fixed equivalence. *(This is the strategy-critic ts230 WATCH,
   now confirmed.)*
3. **Whole-`U` slice site vs per-open slices** — dual uses `restr W = pushforward₀
   (Over.forget W)`, finer than the whole-`U` slice site.

The real missing ingredient: a presheaf+module per-`V` slice-internal-hom comparison + ring-iso
transport (`f^* ℋom(A,B) ≅ ℋom(f^*A,f^*B)` for an open immersion) — ~150–300 LOC, with genuine
`Over.map` coherence risk (thinness does **not** collapse it here, unlike the sheaf root).

## What to attack next — USER DECISION REQUIRED

The descent re-route's binding test failed. Two live options (USER owns the choice):

1. **Divisor `Pic⁰` route** — requires lifting the RR-pause (numbered ~2000–4000 LOC:
   cohomology of smooth proper curves, Serre duality + H¹-vanishing + RR formula). Sidesteps
   `exists_tensorObj_inverse` entirely.
2. **Sanction the varying-ring slice-internal-hom comparison sub-build** (~150–300 LOC) on top
   of the A-engine `homOfLocalCompat`. Only both together can close the inverse.

Do **not** re-bet on `overSliceSheafEquiv` closing C; do **not** build the A-engine in
isolation (the inverse needs C too).

## Findings / patterns

- A value-category-FIXED site equivalence cannot transport a varying-ring module action — the
  general lesson behind the C failure. Recorded as a Known Blocker in PROJECT_STATUS.md.
- The iter-229 shared root remains genuine, axiom-clean, upstream-PR-shaped (completes a named
  Mathlib TODO) — keep it; it is simply insufficient for the inverse.

## Subagent reports (both ran)

- `task_results/lean-auditor-ts230-auditor.md` — 6 must-fix (all pre-existing), 10 major, 6
  minor. Headline: `RelPicFunctor.PicSharp` placeholder (constant functor at `PUnit`); 3
  load-bearing sorries; stale `tensorObj_assoc_iso` docstring + vestigial `FlatWhisker`.
- `task_results/lean-vs-blueprint-checker-ts230-lvb.md` — 0 must-fix, 2 major (blueprint-writer
  items: stale `IsDenseSubsite.sheafEquiv` sketch; chapter prose now lags the probe finding).

## Blueprint markers updated (manual)

- None this iter. The probe added no declaration (a comment block only), so there is no
  `\mathlibok`, `\lean{}` correction, `\notready` removal, or new `% NOTE:` warranted on a
  landed decl. The two lvb major items are blueprint *prose* fixes (blueprint-writer's domain),
  carried to recommendations.md #3.

## Process / tooling notes

- The external-LLM second-opinion tool (`archon-informal-agent.py`) is unavailable this
  session (MOONSHOT/Kimi key → HTTP 401). Non-blocking; flagged for tooling.
