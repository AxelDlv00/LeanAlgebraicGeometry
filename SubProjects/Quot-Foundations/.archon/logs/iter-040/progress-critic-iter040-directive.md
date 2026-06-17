# Progress-critic directive — iter-040 convergence audit

Assess convergence per active route from the signals below. Two active routes (FBC, QUOT); GR closed
iter-038. Verdicts feed the planner's stuck-protocol gate.

## Route FBC — `Cohomology/FlatBaseChange.lean`, conjugate-side discharge of `_legs_conj`
Current phase entered ~iter-034 (conjugate re-encoding). STRATEGY "Iters left": 2–5.
Target: close `base_change_mate_fstar_reindex_legs_conj` (`_legs_conj`) → unblocks `gstar_transpose`.

Signals (last 5 iters), FBC active-sorry count = 4 every iter:
- iter-035: conjugate atomized chain ran (+7 sorry-free decls); residual sorry MOVED into conj-2a
  `_legs_conj`. Status PARTIAL. Tripwire fired (route abandoned then reinstated).
- iter-036: FBC step (b) landed (+2 axiom-clean variants). Status PARTIAL. sorry 4→4.
- iter-037: clean assembly pass of proved atoms — closed NOTHING. Status PARTIAL (tripwire fired). +0.
- iter-038: NO FBC prover (plan-cycle analogist returned KEEP).
- iter-039: built conj-2b + conj-2d (+2 axiom-clean) — the two missing legs; the
  `conjugateEquiv.injective` REFRAMING of `_legs_conj` did NOT close. Status PARTIAL. sorry 4→4.
  Pre-armed KILL-CRITERION fired (atoms land, reframing doesn't).
- Recurring blocker phrase (3 iters): "the section-level `Γ.map`-composite is not syntactically a single
  `conjugateEquiv` value, so `.injective` won't unify" — a pure-wiring wall, all 3 legs in hand.

Planner's iter-040 action for FBC: NO prover round (honoring the kill-criterion). Instead an
api-alignment mathlib-analogist consult to pick fallback (A) element-`ext` reopened with conj-2b/2c/2d as
a change-of-rings dictionary vs (B) a `leftAdjointCompIso` refactor of `_legs`. Question for you: is this
the right corrective TYPE for the signals, or do you read a different one (e.g. immediate refactor)?

## Route QUOT — `Picard/QuotScheme.lean`, gap1 keystone `isLocalizedModule_basicOpen_descent`
gap1 lane active since ~iter-026. STRATEGY "Iters left": 3–7.
Target: build the keystone descent + close gap1 `isIso_fromTildeΓ_of_isQuasicoherent`.

Signals (last 5 iters), QUOT active sorry = 4 every iter (the 4 protected stubs; the keystone is a
NEW decl not yet stubbed, so it never shows as a sorry — track it by "keystone closed? Y/N"):
- iter-035: gap1-D cover form `isLocalizedModule_basicOpen_descent_of_cover` landed (+6). Keystone N.
- iter-036: `gammaPullbackTopIso` section transport landed (+~3). Keystone N.
- iter-037: bridges (I) + (II) landed (+2). Keystone N.
- iter-038: σ_V `gammaImageRingEquiv` + semilinearity landed (+2). Keystone N.
- iter-039: combined `isLocalizedModule_powers_transport` + instantiable `_of_basicOpen_cover` +
  `isIso_fromTildeΓ_of_iso` landed (+3). Keystone N. Prover reports ALL consumers now built; sole
  residual = the geometric "section-transport producer" (basic-open `Hfr`), a ~200–400 LOC build with
  4 named sub-gaps (a 3-fold `pullbackComp` iso; b range/image computations; c ⊤-vs-`D(f')` σ-naturality;
  d f-locus scalar-tower instances).
- Each iter lands 1–3 axiom-clean feeders that ARE consumed; the keystone has stayed open 4 iters because
  each iter peeled one more genuine layer, ending at the now-decomposed geometric producer.

Planner's iter-040 action for QUOT: blueprint-writer decomposes the section-transport producer into a
`\uses`-linked sub-lemma chain (a)–(d) + top lemma `section_localization_hfr_basicOpen`; then a
`mathlib-build` prover attacks sub-gap (a) (the `pullbackComp` 3-fold iso feeding `isIso_fromTildeΓ_of_iso`)
first, building the chain bottom-up. Question for you: is QUOT CONVERGING (genuine layer-by-layer descent
to a now-decomposed final build) or CHURNING (feeders accreting without the keystone shrinking)? If
CHURNING, name the corrective TYPE.

## Proposed iter-040 objectives (dispatch-sanity)
1 prover file: `Picard/QuotScheme.lean` (section-transport producer, sub-gap (a) first). FBC: no prover
(analogist consult). GR: no prover (closed). 1 lane total.
