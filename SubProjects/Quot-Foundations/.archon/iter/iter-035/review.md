# Iter 035 — Review (Quot-Foundations)

## Verdict
Build GREEN — all three prover-touched modules (`FlatBaseChange.lean`, `QuotScheme.lean`,
`GrassmannianCells.lean`) `lake build` exit 0 (pre-existing `sorry` + linter long-line/deprecation
warnings only; QuotScheme 8317 jobs, GrassmannianCells 31–36s). New decls `lean_verify` =
`{propext, Classical.choice, Quot.sound}` (provers + lean-auditor). blueprint-doctor: **0 findings**.
`sync_leanok` (iter 35, sha `42cbcae`): **+72 `\leanok`, 0 removed** (the large count = plan-cycle
coverage writers blueprinting a backlog of already-proven decls; the conj-2a block got statement-`\leanok`
only, NOT proof-`\leanok` — no laundering). leandag `gaps=0`, `unmatched=21` (coverage debt).

**Two-keystones-advanced iter: net 0 active sorry (FBC 4→4, QUOT 4→4 stubs, GR 0→0, GF 1 untouched),
+~20 axiom-clean decls. The FBC-A conjugate route is EXHAUSTED — its tripwire FIRED — and iter-036
pivots to the pre-scheduled explicit-inverse refactor.**

## Overall progress this iter (active `sorry` per file)
- **QUOT 4 → 4 stubs (gap1-D keystone LANDED, cover form).** `isLocalizedModule_basicOpen_descent_of_cover`
  axiom-clean — the full Hartshorne II.5.3 / Stacks `lemma-invert-f-sections` descent assembled by direct
  sheaf-gluing (3 `IsLocalizedModule` fields), NOT through the global affine equivalence (which is gap1
  itself). +6 decls (1 public keystone + 5 private). The NAMED keystone `isLocalizedModule_basicOpen_descent`
  and gap1 stay gated solely on the `Hfr` slice→`Spec R_r` section transport (same wall as P1's object
  transport) — both become one-liners once it lands.
- **GR 0 → 0 (properness reduced to ONE obligation).** 7 axiom-clean decls. `isProper_of_valuativeExistence`
  reduces `Grassmannian.isProper` to the single `ValuativeCriterion.Existence (toSpecZ d r)` via the three
  cheap valuative-criterion ingredients (`compactSpace`/`quasiCompact`/`locallyOfFiniteType` +
  uniqueness-free-from-separated). The existence build's algebraic core `transitionPreMap_minorDet_mul`
  (E3) also landed. Remaining = E1 (chart factorization — primary missing Mathlib API)/E2/E3-combinatorics/E4,
  a fresh phase.
- **FBC-A 4 → 4 (conjugate route EXHAUSTED → TRIPWIRE FIRES).** The atomized conjugate chain ran: 7
  axiom-clean decls (conj-1a/1b, conj-2c, the param-then-`rfl` helpers), `_legs` became a sorry-free thin
  wrapper — but the residual `sorry` only MOVED into the named conjugate identity conj-2a
  (`base_change_mate_fstar_reindex_legs_conj`; `_legs` transitively sorry-backed, `lean_verify` sorryAx).
  Blocker unchanged (5-iter stall): section-composite→`conjugateEquiv`-component reframing the
  explicit-factor vehicle can't express. iter-036 = pre-scheduled explicit-inverse + element-`ext`
  refactor. Do NOT re-assign a conjugate/section round on `_legs`/conj-2a.
- **GF 1 (untouched), gated on gap1.**

## Critic / auditor dispositions (all dispatched this review phase)
- **lean-auditor `iter035`** (all 3 files): **0 must-fix**, 3 major (FlatBaseChange L1693 proof comment
  references `PROGRESS.md` by name; L184–247 stale iter-number narrative; L2122 `gstar_transpose` is a
  SECOND independent sorry site — the file has 4 sorries, not 1), 3 minor. All headline new decls confirmed
  axiom-clean; all 4 FBC sorries honest in-progress work. → recommendations §3.
- **lean-vs-blueprint-checker ×3** (`fbc`/`quot`/`gr`), **0 must-fix-this-iter on any**:
  - `quot` (1 major): cover-form keystone `isLocalizedModule_basicOpen_descent_of_cover` lacks a
    `\lean{}` block (the existing iter-035 NOTE already instructs the planner); representable signature
    shortfall pre-existing/acknowledged.
  - `fbc` (1 major): `lem:base_change_mate_codomain_read_legs` prose/title/`\uses` describe the CONJUGATE
    form but the pin targets the `pullbackComp` (non-conj) decl — a review `% NOTE` was added; planner to
    repoint or revert + move 2 mathlib `\uses` to the `_conj` block. + 4 coverage-debt helpers (minor).
  - `gr` (1 major): all 7 properness-scaffold decls absent from `sec:gr_proper` (coverage debt); 9
    private-decl pins (minor). `lem:gr_proper` pin to the not-yet-existing `isProper` correctly carries no
    false `\leanok`.

## Blueprint markers updated (manual, this review)
- `Cohomology_FlatBaseChange.tex`, `lem:base_change_mate_fstar_reindex_legs_conj` (conj-2a): added
  `% NOTE (iter-035, review)` — the single residual sorry of the `_legs`/conjugate chain (file has 4
  sorry sites total); chain around it is axiom-clean; blocker is the reframing, not a missing lemma;
  tripwire fired → iter-036 pivot; conj-2b/2d not yet typed.
- `Cohomology_FlatBaseChange.tex`, `lem:base_change_mate_codomain_read_legs`: added
  `% NOTE (iter-035, review — lvb-fbc MAJOR)` — prose/`\uses` describe the `_conj` form but the pin is the
  `pullbackComp` decl; planner fix (repoint or revert + move 2 mathlib `\uses`).
- No `\mathlibok` added (all new decls bespoke project infra). No `\notready` stripped (none stale).
  `\leanok` untouched (owned by `sync_leanok`).
- NOT added by review (verified accurate): the `% NOTE (iter-035)` at QUOT `lem:section_localization_descent`
  documenting the cover-form name + `Hfr` gate was authored by the plan-cycle coverage writer.

## What shaped iter-036 (live frontiers)
1. **FBC: PIVOT (do NOT re-assign conjugate/section).** Execute the explicit-inverse + element-`ext`
   affine-local refactor (STRATEGY Open Q2 fallback). Likely a refactor/effort-breaker pass first.
2. **GR: open the existence phase.** Effort-break/dag-walk `sec:gr_proper`; blueprint E1–E4; dispatch E1
   first (chart factorization — consider a `mathlib-analogist` consult for the missing-API idiom).
3. **QUOT: open the `Hfr` section-transport lane** (closes gap1 + the named descent in two one-liners).
4. **Blueprint hygiene (before any prover round on the affected files):** add the cover-form QUOT block,
   the 7 GR properness blocks, and fix the FBC `codomain_read_legs` prose/`\uses` mismatch (HARD GATE
   re-check will need these current).

## Subagent skips
(none — lean-auditor + per-file lean-vs-blueprint-checker all dispatched this phase)
