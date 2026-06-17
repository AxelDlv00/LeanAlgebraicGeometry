# Session 26 (iter-026) — Review Summary

## Metadata
- **Session/iter:** session_26 = iter-026. Model: claude-opus-4-8.
- **Prover lanes (3, all import-independent, parallel):** FBC `inner_value_eq`/`_legs` (fine-grained),
  QUOT G1-core (mathlib-build), GR-glue `Grassmannian.scheme` (mathlib-build).
- **Global sorry change:** net **0** in the three touched files (FBC 5→5, QUOT 4→4, GR 0→0). But
  **16 new axiom-clean declarations** landed (QUOT +5, GR +11) and the FBC headline 4-iter blocker was
  broken at the tactic level.
- **Per-file sorry (end of iter):** FBC 5 (`_legs` @1413, `inner_value_eq` @1646, `gstar_transpose`
  @1829, affine @2002, FBC-B @2024); QUOT 4 (protected stubs @123/161/198/225); GR 0;
  FlatteningStratification 1 (`genericFlatness`, no prover this iter); RegroupHelper/GradedHilbertSerre 0.
- Build: all three prover-edited modules `lake build` GREEN; new declarations `#print axioms` =
  `{propext, Classical.choice, Quot.sound}`. blueprint-doctor: **0 findings**. dag `gaps=0`,
  `unmatched=15` (coverage debt — see recommendations). sync_leanok ran on this tree (sha `d2e6899`,
  iter=26): +2 `\leanok`, chapters_touched = `Picard_QuotScheme.tex`.

## Target-by-target

### FBC — `base_change_mate_fstar_reindex_legs` (PARTIAL, real advance) + `inner_value_eq` (BLOCKED inline)
**Headline: the 4-iteration literal-form lock (iters 018–024) is broken — use `erw`, not `rw`.**
After `subst`, the goal's `(g')`-unit leg is the literal
`(pullbackSpecIso ↑R ↑A ↑R').hom ≫ Spec.map (CommRingCat.ofHom …)`, which is **defeq** to
`e.hom ≫ Spec.map inclA` but differs in invisible implicit args, so `rw [unitExpand …]` reports
"did not find pattern" even though the search pattern prints identically. The prover re-verified that
`rw` fails in **five** distinct argument forms (no-arg unification, `set`-fvar args, exact-literal args,
`simp only`, `hfst.symm ▸`) before finding that
`erw [base_change_mate_fstar_reindex_legs_unitExpand e.hom (Spec.map inclA) (tilde M)]` (definitional
matching) **fires**. This expands the bare unit into the four-factor reindex form — the step four prior
iters could not pass. `lake env lean` EXIT 0. Memory `fbc-subst-legs-literal-form-lock` updated.

Residual on `_legs`: the four distributed Γ-factors must cancel against the `e`-pieces baked into
`base_change_mate_codomain_read_legs`. Distribution is blocked: `simp only [Functor.map_comp]` / `rw
[Functor.map_comp]` make **no progress** (the `X.Modules` `CategoryStruct.comp` instance diamond — the
same one that forced `…_gammaDistribute` into term mode), so distribution must go through the term-mode
`…_gammaDistribute`. After distribution the three proved `inner_eCancel` atoms apply; the lone survivor
`η^{Spec ιA}` reduces via Seam-1 `base_change_mate_unit_value`. ~100 LOC of now-unblocked bookkeeping.

`inner_value_eq` (inline pre-subst route, the directive's prescription): **genuinely walled.** The goal's
leg is `pullback.fst`, only *propositionally* (`hfst`) equal to `e.hom ≫ Spec ιA`, not defeq, so even
`erw [unitExpand]` does not fire inline. Three transport attempts all hit the **leg-dependent-motive
wall**: (1) explicit `have hunit` → equation ill-typed; (2) `hfst.symm ▸ unitExpand` → "failed to compute
motive"; (3) whole-goal `rw [hfst]` → "motive is not type correct" (the codomain read is a closed def
whose type bakes in the leg). **The viable route is the post-subst expansion inside `_legs`** (where the
leg is defeq), after which `inner_value_eq := exact base_change_mate_fstar_reindex ψ φ M` is free.

`gstar_transpose`: not attempted (gated on `inner_value_eq`); Seam-C `huce` scaffold landed prior iter.

### QUOT — `isLocalizedModule_basicOpen_of_isQuasicoherent` (G1-core, NOT built) → downstream glue CLOSED
The assigned keystone target G1-core is the genuine Mathlib-absent descent (Stacks 01HA); the prover
confirmed via `grep` that `IsQuasicoherent`/`fromTildeΓ` connect to nothing outside
`Tilde.lean`/`Quasicoherent.lean`, and that all "easy" forms already exist. Rather than start an isolated,
uncertain step-1 of that descent, the prover **closed the entire downstream glue** so the keystone falls
out the moment G1-core lands. Five axiom-clean declarations:
- `isIso_fromTildeΓ_of_isLocalizedModule_restrict` (public) — **gap1 from G1-core's conclusion with no
  descent**: on each `D(f)` the component intertwines two localizations of `N=Γ(M,⊤)` (source via the
  `tilde.toOpen` instance, target by hypothesis), so it is the canonical localization iso;
  `isIso_sheaf_of_isIso_app_basicOpen` upgrades basis-wise iso to a sheaf iso, then
  `SpecModulesToSheafFullyFaithful` reflects to `IsIso M.fromTildeΓ`.
- `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (public) — the `iff` characterization.
- `isIso_sheaf_of_isIso_app_basicOpen` (private) — "iso on the basic-open basis ⟹ iso of sheaves".
- `bijective_comp_of_localizations` (private) — diamond-safe, two `IsLocalizedModule` facts explicit.

Net: `G1-core ⟹ gap1 ⟹ keystone` is fully wired and axiom-clean **except for G1-core itself**.
Key Lean gotchas recorded: `TopCat.Sheaf` is an `InducedCategory` (morphism's presheaf hom is `α.1`,
not `α.val`; object presheaf is `.presheaf`, `.val` deprecated); inline `set toO/res` triggers a TC
**zeta-unfold** that loses the `IsLocalizedModule (powers f)` hypothesis instance — isolate as a lemma
with explicit `IsLocalizedModule` hypotheses.

### GR — `Grassmannian.scheme` (NOT built) → scheme-level transition layer CLOSED (11 decls, 0 sorry)
Built the 7 "easy" `Scheme.GlueData` fields (`U,V,f,f_open,f_id,t,t_id`) as named axiom-clean decls,
**plus** the linchpin pullback iso `awayPullbackIso`
(`pullback(Spec R[1/x]→Spec R←Spec R[1/y]) ≅ Spec R[1/(xy)]`) with both leg-compatibility lemmas, plus
`awayMulCommEquiv` (the `orderSwap` `R[1/(xy)] ≃+* R[1/(yx)]`). The remaining fields (`t'`, `t_fac`,
`cocycle`, `.glued`) are one connected construction — blocked on volume + the **product-order subtlety**
(`a*b` vs `b*a` are distinct propositional types), not a missing Mathlib fact. Two reusable gotchas:
(1) `infer_instance` fails after `unfold chartIncl` — use `inferInstanceAs (IsOpenImmersion (Spec.map …))`;
(2) plugging the heavy chart ring `R^I = MvPolynomial (Fin d × {q//q∉I}) ℤ` directly into
`IsScalarTower`/tensor synthesis **times out** (20000 hb) — state helpers over a generic base ring `A`.

## Key findings / patterns
- **`erw` vs `rw` for defeq-but-not-syntactic subterms** is the headline reusable lesson: after `subst`,
  legs lock into a literal form that is defeq but implicit-arg-divergent from the `set`-abbreviations; `rw`
  is syntactic and fails, `erw` does definitional matching and fires. Inverse caveat: `erw` still cannot
  cross a *propositional* (non-defeq) leg equality — that is the inline-`inner_value_eq` wall.
- **`X.Modules` `CategoryStruct.comp` instance diamond** repeatedly defeats `simp/rw [Functor.map_comp]`;
  distribution there must be term-mode (`…_gammaDistribute`).
- **`IsLocalizedModule` as a hypothesis vs an instance**: inline `set` zeta-unfolds and loses the
  hypothesis-supplied instance; pass `IsLocalizedModule` facts as explicit lemma arguments.
- **Generic-ring helper discipline**: never feed the heavy `MvPolynomial` chart ring into
  `IsScalarTower`/tensor TC synthesis (timeout); prove over a generic base and instantiate.

## Subagent reports (this iter)
- `lean-auditor` → `.archon/task_results/lean-auditor-iter026.md` (16 issues; GR clean, QUOT clean,
  FBC 3 stale/false-completion comment must-fixes).
- `lean-vs-blueprint-checker fbc` → `.archon/task_results/lean-vs-blueprint-checker-fbc-iter026.md`
  (blueprint faithful + adequate; findings are the known sorries).
- `lean-vs-blueprint-checker quot` → `.archon/task_results/lean-vs-blueprint-checker-quot-iter026.md`
  (2 new public decls uncovered; **prover's re-pointing suggestion is wrong — block it**; ordering acyclic).
- `lean-vs-blueprint-checker gr` → `.archon/task_results/lean-vs-blueprint-checker-gr-iter026.md`
  (must-fix: `def:gr_glued_scheme` under-specified; 11 decls uncovered; 9 private-name `\lean{}` mismatches).

## Notes (LOW)
- One harmless lint remains in GR (`simpa`→`simp` at L689); build GREEN.
- `archon-informal-agent.py` unavailable all iter (no LLM API key in env — only `GEMINI_CLI_*`, not
  `GEMINI_API_KEY`); loogle timed out repeatedly (grep over Mathlib source used instead).

## Blueprint markers updated (manual)
- **None this iter.** Rationale: the 15 unmatched `lean_aux` nodes (11 GR + 4 QUOT) have **no blueprint
  block yet**, so there is nothing to mark — they require the plan agent to author prose first (listed in
  `recommendations.md`); `\mathlibok` anchors and `\lean{}` pins are added once those blocks exist. No
  `\notready` markers exist on any chapter. No prover renamed an existing-block declaration this iter. The
  QUOT prover's suggested re-point of `lem:qcoh_affine_isIso_fromTildeΓ`'s `\lean{}` was **rejected** by
  the lvb checker (signatures differ) and deliberately **not** applied.
