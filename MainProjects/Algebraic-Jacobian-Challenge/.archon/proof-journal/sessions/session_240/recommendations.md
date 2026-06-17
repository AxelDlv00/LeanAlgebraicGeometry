# Recommendations for the next plan iteration (post iter-240)

## CRITICAL / must-fix-this-iter

1. **[BLUEPRINT] `lem:pushforward_spec_tilde_iso` proof sketch is under-specified for the `hsq` naturality step — dispatch a blueprint-writer BEFORE the next FlatBaseChange prover pass.**
   (lean-vs-blueprint ts240-fbc must-fix.) The chapter treats naturality-in-the-open of
   `gammaPushforwardIsoAt` as "follows from the construction"; in Lean that is the residual `hsq`
   sorry, and the prover could not close it from prose alone. The writer must:
   (a) add a NEW pinned block for the **naturality of `gammaPushforwardIsoAt`** — a `NatIso`
   (or `NatTrans`-commutativity lemma) `∀ U' ≤ U, restriction ≫ (e_{U'}).hom = (e_U).hom ≫
   restrictScalars φ (restriction)`; (b) revise the `lem:pushforward_spec_tilde_iso` sketch to cite
   that NatIso as the driver of the `hloc` transport, naming the prover's repackage-as-`NatIso`
   route. This is the precise ingredient that closes `hsq`. HARD GATE: do not re-dispatch the
   FlatBaseChange prover on `pushforward_spec_tilde_iso` until this block is in and a scoped
   blueprint-review clears the chapter. Report: `task_results/lean-vs-blueprint-checker-ts240-fbc.md`.

## HIGH — act this iter (blueprint pins + marker state)

2. **[BLUEPRINT] Pin the two new axiom-clean TensorObjSubstrate decls.** (lean-vs-blueprint
   ts240-tensorobj, 3 MAJOR.) `pullbackObjUnitToUnit_comp` (the "genuinely-new ingredient" for
   `lem:pullback_unit_iso`) and `unitToPushforwardObjUnit_comp` (its pushforward-side input) have
   NO `\lean{...}` block in `Picard_TensorObjSubstrate.tex`. Dispatch a blueprint-writer to:
   add a lemma block for `pullbackObjUnitToUnit_comp`
   (`pbu(h≫f) = (pullbackComp h f).inv.app unit ≫ (pullback h).map(pbu f) ≫ pbu h`) with the pin,
   a remark referencing `unitToPushforwardObjUnit_comp` + the adjunction-mate route, and **revise the
   `lem:pullback_unit_iso` sketch** — it currently calls "the naturality lemma" the remaining work,
   but that lemma IS now proved; the real remaining blocker is the instance-synthesis plumbing
   (NOT math). Report: `task_results/lean-vs-blueprint-checker-ts240-tensorobj.md`.

3. **[MARKER — partly handled this iter] Statement `\leanok` missing on `lem:pushforward_spec_tilde_iso`.**
   (lean-vs-blueprint ts240-fbc Major #1.) The decl has a sorry-bearing body, so the statement block
   should carry `\leanok` per sync rules; a `% NOTE:` comment placed BETWEEN `\begin{lemma}` and its
   `[title]` arg was malformed and likely blocked sync. **Review agent fixed the malformation this
   iter** (relocated + updated the NOTE — see "Blueprint markers updated"). Next iter's `sync_leanok`
   should now insert the statement `\leanok` deterministically; the plan agent need only confirm it
   appears (do NOT hand-add it).

## The two lanes — next prover steps

### Lane A — `Picard/TensorObjSubstrate.lean` (Route Z / Phase 1, critical path) — CONVERGING
- **Status:** the linchpin `pullbackObjUnitToUnit_comp` is LANDED axiom-clean. `pullbackUnitIso` is
  blocked ONLY on instance-synthesis plumbing (NOT math); the full per-chart recipe + globalizer is
  written into the in-file HANDOFF (L1011).
- **Next step (ranked, from prover + auditor):**
  1. Build each component iso (`IsIso (pbu U.ι)`, `IsIso (pbu g)`, `IsIso ((pullbackComp g U.ι).inv.app _)`)
     as a fully **type-ascribed named `Iso`** BEFORE the `pullbackObjUnitToUnit_comp` rewrite, then
     `convert`/transport `IsIso` across the coherence equation (pins implicits, no re-synthesis).
  2. Or add `@[instance] lemma isIso_pullbackObjUnitToUnit_of_final` with the canonical implicit
     shape and apply it `@`-explicitly at each site. **CAVEAT (lean-auditor):** the name
     `instIsIsoPullbackObjUnitToUnitOfFinal` cited in the HANDOFF/blueprint is ABSENT from Mathlib
     and all project `.lean` — verify the real name via `lean_local_search` first.
  3. Or mathlib-analogist consult on `pullbackObjUnitToUnit` instance canonicity.
  This is a contained instance-plumbing task; once cleared, `pullbackUnitIso` lands → Phase 2
  (pointwise `pullbackTensorIso`) + Phase 3 (`IsInvertible.pullback`) remain.
- **Reversing signal (from iter-240 plan, still live):** if Phase 1 ALSO fails to close (≥3 helpers,
  no iso), mathlib-analogist on the `pullbackObjUnitToUnit`/`pullbackComp`/`restrictFunctorIsoPullback`
  cluster BEFORE re-dispatch. The work this iter was substantive (linchpin landed), so this is the
  first genuine attempt at the assembly, not a churn — proceed, but watch.

### Lane B — `Cohomology/FlatBaseChange.lean` (`pushforward_spec_tilde_iso`, engine)
- **Status:** the 4-iter carrier wall is BROKEN (`algebraize` works). Sole residual = `hsq`
  (naturality-in-the-open square). **Sorry count did NOT drop** (3→3); per the iter-240 plan's armed
  reversing signal, this is the point where the next step is NOT another in-tree rewrite attempt.
- **DO NOT** retry any of the ~15 rewrite forms already tried on `hsq` (`rw [nat1]`,
  `reassoc_of%`, `slice_lhs`, `conv_lhs`, `set X`, `simp ..._inv_naturality_assoc`) — all fail
  identically on the `restrictScalarsComp'App .inv` unification.
- **Next step (ranked):**
  1. **GATE on the CRITICAL blueprint fix above**, then refactor `gammaPushforwardIsoAt` into a
     genuine `NatIso` (`NatIso.ofComponents`) so `hsq` becomes the `.naturality` field
     (definitional). It lives in THIS file; consumers use only `.app U`.
  2. If the NatIso refactor stalls, take the **Mathlib bump #37189** (`isIso_fromTildeΓ_pushforward`)
     — the recorded HARD reversing-signal; collapses the def to ~3 lines. The iter-240 plan deferred
     it as disruptive mid-flight, with the cheapest signal being "FlatBaseChange sorry stays flat" —
     which it now is. Weigh the bump seriously.
  3. After `hsq` closes, `affineBaseChange_pushforward_iso` still needs the pullback/`cancelBaseChange`
     dictionary (independent of this brick) and `flatBaseChange_pushforward_isIso` the Čech route.

## Lower-priority cleanup (Lean comments — prover/refactor domain, NOT review's)
(lean-auditor ts240, 2 MAJOR + 4 MINOR — `task_results/lean-auditor-ts240.md`)
- TensorObjSubstrate `## Status (current)` header (L39–50) is stale: omits the 3 new axiom-clean
  decls (`unitToPushforwardObjUnit_comp`, `pullbackObjUnitToUnit_comp`, `sheafifyTensorUnitIso`) and
  §6; also mixes per-file vs per-project (`PresheafInternalHom.lean`) status. Refresh next refactor pass.
- TensorObjSubstrate L710–711: stale "(80→79)" sorry-count comment in `exists_tensorObj_inverse`.
- TensorObjSubstrate L913: dangling `pullbackUnitIso` forward-ref in the `pullbackObjUnitToUnit_comp`
  docstring (HANDOFF clarifies; harmless).
- FlatBaseChange L625–628: `nat1` is a live but UNUSED `have` (dead code → unused-var warning).
  Comment it out until `hsq` is wired up.
  These are non-blocking; bundle into the next prover/refactor touch of each file.

## Known blockers — do NOT re-assign without a structural change
- FlatBaseChange `hsq`: do not retry the failed rewrite forms; the route is the `NatIso` refactor or
  the #37189 bump (see Lane B).
- `IsInvertible.pullback` via sectionwise `extendScalars`: confirmed structurally impossible
  (iter-239); Route Z (local-chart finality) is the live path — do not resurrect the sectionwise recipe.

## Reusable proof patterns discovered this iter (also in PROJECT_STATUS Knowledge Base)
- Adjunction-mate transport for pushforward/pullback unit-comparison composition coherence (the
  pattern that landed `pullbackObjUnitToUnit_comp` from the easy `unitToPushforwardObjUnit_comp`).
- `SheafOfModules R` compositions are defeq-but-not-syntactic ⇒ use `erw` (never `rw`) for every
  assoc/functoriality/sub-lemma coherence rewrite; bridge `homEquiv_unit` HO-match with explicit
  `e := Adjunction.homEquiv_unit (adj:=…)(X:=…)(Y:=…)(f:=…)` then `e.symm.trans`.
- `algebraize [φ.hom]` (NOT `Module.compHom` letI) + `@IsLocalizedModule.powers_restrictScalars` with
  explicit instances is the carrier-wall fix for `restrictScalars`-of-section localizations.
