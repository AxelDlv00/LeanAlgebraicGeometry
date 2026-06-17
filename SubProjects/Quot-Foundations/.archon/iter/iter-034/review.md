# Iter 034 — Review (Quot-Foundations)

## Verdict
Build GREEN — all four prover-touched modules (`FlatBaseChange.lean`, `FlatBaseChangeGlobal.lean`,
`GrassmannianCells.lean`, `QuotScheme.lean`) `lake build` exit 0 (pre-existing `sorry` + linter
long-line/deprecation warnings only). The ~37 new declarations `#print axioms` =
`{propext, Classical.choice, Quot.sound}` (verified by provers + lean-auditor). blueprint-doctor:
**0 findings**. `sync_leanok` (iter 34, sha `b41177a`): **+19 `\leanok`, 0 removed**; chapters =
FlatBaseChange / GrassmannianCells / QuotScheme. leandag `gaps=0`, `unmatched=33` (coverage debt).

**Three-keystones-landed iter: net 0 active sorry (FBC 4→4, QUOT 4→4 stubs, GR 0→0, FBCGlobal 0→0,
GF 6 untouched), +~37 axiom-clean decls.** Three of four lanes hit their pinned keystone; only
FBC-A's deep `_legs` crux remains and its conjugate foundation (conj-0) landed without closing it.

## Overall progress this iter (active `sorry` per file)
- **GR 0 → 0 (LANE CLOSED — keystone landed).** `Grassmannian.isSeparated` (`lem:gr_separated`)
  axiom-clean via route (b). `Spec ℤ` genuinely terminal for `Scheme.{0}` collapses the glue
  assembly to `IsTerminal.hom_ext`; `isSeparatedToSpecZ` is a faithful `Proj.isSeparated` port
  (per-patch closed immersion from `diagonalRingMap_surjective`). +7 decls. Only `lem:gr_proper`
  (valuative criterion) remains in the GR cone — a fresh phase, out of scope.
- **QUOT 4 → 4 (gap1 P1 COMPLETE — keystone landed).** `isIso_fromTildeΓ_restrict_basicOpen`
  axiom-clean via the 5-step affine descent; the general `isIso_fromTildeΓ_presentationPullback`
  (the form gap1-D consumes) also landed. +7 decls. The 4 file-counted sorries are the unchanged
  protected stubs. Next: gap1-D (`section_localization_descent`) — verify the Stacks tag first.
- **FBC-B 0 → 0 (sub-lane + payoff DONE, advanced independently).** `gammaTopEquivEqLocus` (H⁰ as
  A-module equalizer) + `baseChangeGammaEquiv` (flat base change commutes with the H⁰ equalizer),
  +13-15 decls. The geometric chain assembly stays gated on FBC-A's affine sorry. Realizes the
  strategy-critic's parallelism corrective (no longer waits on `_legs`).
- **FBC-A 4 → 4 (PARTIAL, conj-0 foundation landed, keystone did NOT close → TRIPWIRE FIRES).**
  Two axiom-clean lemmas `pullbackComp_{inv_}eq_leftAdjointCompIso{_inv}` (the Step-(i) device for
  the conjugate re-encoding; confirmed pinned Mathlib has the full `CompositionIso` calculus). conj-1
  (codomain-read re-cut) deferred — the existing read is consumed definitionally by a green concrete
  `exact`, so the safe path is new-def-then-bridge, larger than a fine-grained step; conj-2 blocked
  on conj-1. iter-035 = ONE more re-break; iter-036 escalates if it closes nothing.
- **GF 6 (untouched), gated on gap1.**

## Critic / auditor dispositions
- **lean-auditor `iter034`** (all 4 files): 0 critical, 3 major (deprecated `Sheaf.val` >20 sites in
  FBC; 5 misplaced `maxHeartbeats` comments), 8 minor. All 4 headline groups axiom-clean; the 4 FBC
  sorries are honest in-progress work, not dead code. → recommendations §4.
- **lean-vs-blueprint-checker ×4** (all prover-touched), **0 must-fix-this-iter on any**:
  `grassmanniancells` (2 major: 9 private-decl pins, stale NOTE **FIXED**), `quotscheme` (4 major:
  stale NOTE **FIXED**, 6 helper coverage gaps, 4 gap1-assembly absences blueprint-acknowledged,
  2 skeleton gaps), `fbcglobal` (3 broken pins, 2 unreferenced decls), `fbc` (3 stale `_link_*` pins,
  2 conj-0 coverage gaps). → recommendations §2/§3.

## Blueprint markers updated (manual, this review)
- `lem:gr_separated`: stale iter-033 NOTE ("isSeparated does NOT yet exist … doc-comment reduction")
  → RESOLVED-and-axiom-clean route-(b) note.
- `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`: stale NOTE ("the pinned decl does NOT yet
  exist") → RESOLVED-and-axiom-clean 5-step-affine-descent note.
No `\leanok` touched; no `\mathlibok` added (new decls are bespoke project infra).

## What shaped iter-035 (live frontiers)
1. **FBC-A: ONE more conjugate round (tripwire), then escalate.** conj-1 new-def-then-bridge + conj-2
   `.surjective`/`.injective`. No direct-on-sections.
2. **Coverage debt: blueprint the 33 `lean_aux` nodes** (15 FBCGlobal, 6 QUOT, 6+3 GR, 2+1 FBC).
3. **QUOT-D readiness:** verify the Stacks tag, then blueprint + dispatch `section_localization_descent`.
4. **Deprecation cleanup:** schedule a mechanical `Sheaf.val → ObjectProperty.obj` pass on FBC.

## Subagent skips
- None. lean-auditor + all four lean-vs-blueprint-checkers dispatched (4 prover-touched files).
