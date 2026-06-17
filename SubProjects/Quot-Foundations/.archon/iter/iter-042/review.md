# Iter 042 — Review (Quot-Foundations)

## Verdict
Build GREEN — the one prover-touched module `QuotScheme.lean` `lake build` exit 0 (8317 jobs; style /
long-line / `maxHeartbeats`-comment warnings + the 4 pre-existing protected iter-176 scaffold `sorry`s
only). All 5 new decls `lean_verify` = `{propext, Classical.choice, Quot.sound}` (G1-core + gap2-core
independently re-checked this phase, no source-scan warnings). blueprint-doctor: **0 findings**.
`sync_leanok` (iter 42, sha `a55fdae`): **+5 `\leanok`, 0 removed** (Picard_QuotScheme only). leandag
`gaps=0`, `frontier=7`, `unmatched=4`.

**CONVERGING-progress iter: net 0 active sorry (QUOT 4→4 protected stubs), +5 axiom-clean decls. Planner
objective (1) G1-core CLOSED; objective (2) gap2 advanced to ~80% — both the gap2-core transport
(`section_localization_hfr_aux_general`) and the irreducible crux coherence
(`fromSpec_image_top_section_coherence`, the blueprint's flagged "sole new piece") landed. gap2 itself
left ABSENT (no sorry, mathlib-build discipline) pending Piece A (QC-under-pullback, a NEW Mathlib-absent
gap) + Piece B (mechanical eqToHom bridge whose only non-trivial input is the proven crux). FBC / GR /
GF: no prover lane (FBC's mandatory affine-tilde-transport round is scheduled iter-043 per the iter-042
plan).**

## Overall progress this iter (active `sorry` per file)
- **QUOT 4 → 4 stubs (G1-core CLOSED; gap2 80% — core + crux landed, gap2 deferred).** +5 axiom-clean
  non-private decls: `restrictₗ` (2251), `restrictBasicOpenₗ` (2267), `fromSpec_image_top_section_coherence`
  (2288, the crux), `section_localization_hfr_aux_general` (2321, gap2-core), and
  `isLocalizedModule_basicOpen_of_isQuasicoherent` (2433, G1-core, objective (1) DONE). gap2
  `isLocalizedModule_basicOpen` left ABSENT pending two precisely-scoped pieces (see recommendations §0).
- **FBC 4 (untouched).** No prover lane (conjugate route exhausted iter-041, pivot executed iter-042). The
  affine tilde-transport round is the iter-043 mandatory dispatch.
- **GR 0 (untouched — properness lane closed iter-038).** GR-quot/repr a new-file phase.
- **GF 1 (untouched), gated on gap2 + the iter-043 QuotScheme import.**

## Strategic state — QUOT gap2 endgame
gap2 is genuinely close: the two hard mathematical pieces (general-`X` transport core + the `eqToHom`
section-coherence crux) are done and verified. What remains is one distinct sub-build (Piece A, QC
preserved under pullback along `hU.fromSpec` — Mathlib-absent, a `QuasicoherentData` cover-refinement) and
one mechanical assembly (Piece B). The QUOT route has been long (~15 iters since the section-localization
arc opened) but is converging cleanly; iter-043 should land gap2 if Piece A goes through, unblocking GF-G1.

## Critic / auditor dispositions (this review phase)
- **lean-auditor `quot-iter042`**: 0 critical / 1 major / 5 minor. All 5 decls honest + axiom-clean; the
  `letI : Module … := Module.compHom …` + `show … from restrictₗ` idiom certified sound (no defeq
  weakening — the in-scope module instance matches `restrictₗ`'s return type and the `letI iAN₂` body).
  Major = G1-core (2433) duplicates the signature of `isLocalizedModule_basicOpen_descent` (2396) → a
  dedup/naming decision (recommendations §2). Minors → recommendations §5. Report archived to
  `logs/iter-042/lean-auditor-quot-iter042-report.md`.
- **lean-vs-blueprint-checker `quot-iter042`**: 0 must-fix / 2 major. G1-core `\lean{...}` pin matches
  exactly; gap2 correctly absent with `% NOTE`. Major (blueprint-side, iter-043 prep): the gap2 sketch
  omits the eqToHom-bridge crux and still frames the transport as the "sole new piece" though the core
  helper already exists → recommendations §1 (blueprint-writer before the iter-043 gap2 prover). Major
  (carry-forward, pre-existing): `Grassmannian.representable` Lean weaker than blueprint prose.

## Reusable patterns recorded (→ PROJECT_STATUS Knowledge Base)
- `show … from`-ascription requirement for `IsLocalizedModule (powers f) (restrictₗ M i)` (metavar
  elaboration-order instance failure).
- `← eqToHom_map` folding (stray Spec-presheaf `eqToHom` → `presheaf.map`, then `Subsingleton.elim` on the
  forced `op ⊤ ⟶ op ⊤`) for `fromSpec`-section coherence.
- Same-ring shortcut: a `Spec R`-anchored localization-transport ports to a general scheme WITHOUT the
  `restrictScalars` bridge when the localization ring is taken locally (`Γ(X, j ''ᵁ ⊤)`).
