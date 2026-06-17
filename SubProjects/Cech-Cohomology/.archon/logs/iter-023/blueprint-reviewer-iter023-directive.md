# Blueprint-reviewer directive — iter-023 (whole-blueprint audit, HARD GATE)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`). Per-chapter completeness + correctness
checklist as usual; the cross-chapter view is the point.

This iter's HARD-GATE consumers — the two files about to receive prover work — and the chapter that
backs them (one consolidated chapter `Cohomology_CechHigherDirectImage.tex`, carrying
`% archon:covers`):

1. **`FreePresheafComplex.lean`** — prover will build `cechFreeEvalEngineIso` (the differential
   comm-square) + the nonempty glue → `cechFreeComplex_quasiIso`. Verify these blocks are now
   complete + correct after this iter's blueprint-writer pass:
   - NEW `lem:cech_engine_complex` (14 engine decls).
   - `lem:cech_free_eval_engine_iso` (expanded 3-layer naturality/variance proof sketch).
   - `lem:cech_free_eval_prepend_homotopy{,_spec}` (re-leveled to engine→eval transport corollaries).
   - `lem:cech_free_eval_nonempty`, `lem:cech_free_complex_quasi_iso`.
   Confirm NO `\lean{}` pin in these blocks names a non-existent declaration, and every `\uses{}`
   resolves (the lean-vs-blueprint-checker flagged 6 majors here last iter — all blueprint-side; this
   pass should confirm they are resolved).

2. **`CechBridge.lean`** — prover will scaffold + build `ses_cech_h1`. Verify `lem:ses_cech_h1` is
   complete + correct (statement + source quote + proof sketch detailed enough to formalize). It must
   be self-contained: it takes the Ȟ¹(𝒰,F)=0 vanishing as a HYPOTHESIS, so it does NOT depend on
   `injective_cech_acyclic` or `cechFreeComplex_quasiIso`.

For EACH chapter give the explicit `complete: true|false` and `correct: true|false` verdict and any
must-fix-this-iter findings, so I can apply the per-file HARD GATE before dispatching provers on the
two files above.

Also report any unstarted-phase blueprint proposals as usual.
