# iter-040 review

## Overall progress this iter
- **Total sorry:** 2 → 2 (no regression). Both frozen/superseded (dead `CechAcyclic.affine`, frozen
  P5b `CechHigherDirectImage`). Prover file `QcohRestrictBasicOpen.lean` is 0-sorry.
- **Build:** GREEN. `lake env lean … QcohRestrictBasicOpen.lean` EXIT 0; all 4 new decls `#print
  axioms` = `{propext, Classical.choice, Quot.sound}` (re-verified by review via `lean_verify` on all
  four).
- **Lanes planned 1, ran 1** (`mathlib-build`). **+4 axiom-clean decls**, 0 new sorries.
- **dag-query:** gaps = 0, unmatched = 3 (1 dead + 2 new helpers). `sync_leanok` ran iter 40 (sha
  `fd009ba`, +4/−0). **blueprint-doctor:** no structural findings.

## Headline — Route B B3 object iso + B4 closed on the first genuine attempt; the B-chain leaves are complete
iter-039's objective was noop-dropped (the `_SCAFFOLD_RE` keyword trap; 0 provers). The planner
re-dispatched the identical objective with the corrected keyword (D1) and rebutted the iter-039
litmus-CHURNING precondition as unmet (D2 — there was no prior *prover* slip, only a noop-drop). That
read was vindicated: the first real attempt landed **both named targets plus two helpers**, all
axiom-clean — `overBasicOpenIsoRestrict` (the load-bearing B3 object iso),
`presentationModulesRestrictBasicOpen` (B4), `restrictBasicOpenUnitIso`,
`pullbackObjUnitToUnit_isIso_basicOpen`. The entire B3+B4 lane is now done; the keystone assembly
`qcoh_section_isLocalizedModule` is unblocked for iter-041.

## This iter's analysis
- **No forced mathematics; clean landing.** The `mathlib-build` no-sorry invariant held; the lane
  delivered every target with nothing left blocked.
- **Two soundness-risk patterns audited and cleared.** lean-auditor confirmed (a)
  `set_option backward.isDefEq.respectTransparency false` is elaborator-only — the kernel re-checks
  independently; and (b) the `ext U : 3; simp; rfl` closing the `pushforwardCongr` data equality is a
  genuine definitional rfl (pre-`rfl` goal = `forget₂.map` of identities on defeq opens), NOT the
  known thin-category spurious-rfl trap. This is the most important correctness fact of the iter.
- **No must-fix on the Lean from either reviewer.** lean-auditor `iter040`: SOUND, 0/0/3 (all
  pre-existing minor). lean-vs-blueprint-checker `qrbo`: 0 red flags / 2 major / 4 minor — all
  blueprint coverage/scope, not Lean correctness.
- **The friction this iter was instance/universe plumbing, not mathematics:** discrimination-tree
  IsContinuous mismatch on `.toScheme` sites, inline `PreservesColimitsOfSize` synth, universe pins on
  `ofIsIso`/`restrictFunctor`. All resolved with documented idioms (see Knowledge Base).

## Markers / coverage
- **Manual marker edit (1 `% NOTE` rewrite):** `lem:restrict_over_compat` — replaced the stale
  `% NOTE: to-build … NOT YET built` with a `% NOTE:` recording the decl is BUILT + axiom-clean and
  flagging the prose/signature SCOPE MISMATCH (prose = full B3c codomain `(Spec R_g).Modules`, Lean =
  B3b intermediate `D(g).toScheme.Modules`) for the planner to reconcile. No `\leanok` touched, no
  `\mathlibok` (all project theorems), no `\lean{}` rename (pin correct).
- **Coverage debt = 3 unmatched:** 2 new helpers (`restrictBasicOpenUnitIso`,
  `pullbackObjUnitToUnit_isIso_basicOpen`) need blueprint nodes (folded into B4's `\uses`/`\lean`) +
  1 pre-existing dead `CechAcyclic.affine`. Listed for the planner in `recommendations.md`.

## Subagent skips
- (none — both highly-recommended review subagents dispatched: lean-auditor `iter040`,
  lean-vs-blueprint-checker `qrbo`.)
