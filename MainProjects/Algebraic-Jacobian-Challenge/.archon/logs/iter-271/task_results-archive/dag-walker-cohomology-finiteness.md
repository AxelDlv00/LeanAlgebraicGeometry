# DAG Walker Report

## Slug
cohomology-finiteness

## Seed
thm:Scheme_module_finite_gammaObj_of_isProper

## Status
COMPLETE — cone fully wired; one strategy flag surfaced (see "Could not complete").

## Cone before → after
- ∞ holes: 0 → 0 (all listed nodes were already proved/finite-effort; the defect was wiring, not missing proofs)
- broken \uses introduced: 0 (pre-existing project total in `unknown_uses` is 1, unrelated: `thm:genus_zero_curve_iso_p1` → `cor:nonconstant_function_genus_zero`)
- Seed `dep_count`/`rdep_count`: 0/0 → **2/1**; seed cone now resolves to 4 finite (effort-0) ancestors.
- blocks added: 0 (no new statement blocks needed — every dependency already had a block)
- \uses edges added: **20** across StructureSheafModuleK; \lean{} pins added: **2** (FlatBaseChange TODO placeholders)
- Every one of the ~26 directive-listed nodes went from isolated (`dep=0 rdep=0`) to wired (`dep≥1` or `rdep≥1`).

## \uses edges added (the completeness fixes) — `Cohomology_StructureSheafModuleK.tex`

Each edge transcribes the actual Lean proof body in
`AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean`.

Čech chain:
- `def:Scheme_cechCochain_OC` → `def:Scheme_toModuleKSheaf` (built from underlying presheaf of the k-module structure sheaf).
- `def:Scheme_cechCohomology_OC` → `def:Scheme_cechCochain_OC` (homology of the complex).
- `def:Scheme_cechCohomology` → `def:Scheme_cechCochain` (parameterised homology).
- `thm:Scheme_cechCochain_OC_eq` → `def:Scheme_cechCochain_OC, def:Scheme_cechCochain, def:Scheme_toModuleKSheaf` (the `rfl` bridge at F=O_C).
- `thm:Scheme_cechCohomology_OC_eq` → `def:Scheme_cechCohomology_OC, def:Scheme_cechCohomology, def:Scheme_toModuleKSheaf`.
- (`def:Scheme_cechCochain` is a genuine leaf: built only from Mathlib's `cechComplexFunctor`; F is a parameter — no project dep, now wired via its two consumers.)

H⁰ finiteness transports + curve specialisations:
- `thm:Scheme_module_finite_HModule_prime_zero` → `def:Scheme_HModule_prime_zero_linearEquiv` (transport `Module.Finite.equiv` across the open H⁰ bridge; mirror of the already-wired global version).
- `thm:Scheme_module_finite_HModule_zero_curve` → `thm:Scheme_module_finite_HModule_zero, def:Scheme_toModuleKSheaf`.
- `thm:Scheme_module_finite_HModule_prime_zero_curve` → `thm:Scheme_module_finite_HModule_prime_zero, def:Scheme_toModuleKSheaf`.

Affine-vanishing carrier (live; consumed by MayerVietoris `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`):
- `thm:Scheme_IsAffineHModuleVanishing` → `def:Scheme_HModule_prime` (class field is `Subsingleton (HModule' k F i U)`).
- `thm:Scheme_module_finite_HModule_prime_of_isAffineHModuleVanishing` → `thm:Scheme_IsAffineHModuleVanishing, def:Scheme_HModule_prime`.

Wholespace carrier (the LIVE H⁰ engine):
- `thm:Scheme_module_finite_HModule_zero_of_isHModuleHomFinite` → `thm:Scheme_IsHModuleHomFinite, thm:Scheme_module_finite_HModule_zero`.
- `thm:Scheme_module_finite_HModule_zero_of_isHModuleHomFinite_curve` → `thm:Scheme_module_finite_HModule_zero_of_isHModuleHomFinite, def:Scheme_toModuleKSheaf`.
- (`thm:Scheme_IsHModuleHomFinite` is a genuine leaf: the global Hom-from-constant-sheaf group — Mathlib `constantSheaf`, no project dep — now wired via its two consumers.)

Seed + producer assembly:
- **`thm:Scheme_module_finite_gammaObj_of_isProper` (SEED)** → `thm:Scheme_module_finite_globalSections_of_isProper, thm:Scheme_SheafGammaObj_linearEquiv_top` (Lean body: `Module.Finite.equiv (SheafGammaObj_linearEquiv_top …).symm` on top of `module_finite_globalSections_of_isProper`).
- `def:Scheme_constantSheafGammaHom_linearEquiv` (not directive-listed, but the cone hinge) → `lemma:Adjunction_left_adjoint_linear, lemma:Adjunction_right_adjoint_linear, def:Adjunction_homLinearEquiv` (the three `haveI`/`homLinearEquiv` calls in its body). **This is the edge that wires all three Adjunction nodes into the cone.**
- `inst:Scheme_instIsHModuleHomFinite_toModuleKSheaf` → `thm:Scheme_module_finite_gammaObj_of_isProper, def:Scheme_constantSheafGammaHom_linearEquiv, def:Scheme_homFromOne_linearEquiv, thm:Scheme_IsHModuleHomFinite`.
- (`lemma:Adjunction_left_adjoint_linear`, `lemma:Adjunction_right_adjoint_linear`, `def:Adjunction_homLinearEquiv`, `def:Scheme_homFromOne_linearEquiv` are general/Mathlib-gap leaves with no project `\uses`; all four are now reachable via the two consumers above.)

## \lean{} pins added — `Cohomology_FlatBaseChange.tex`
Neither gap node has a standalone Lean declaration: both are inline `sorry`-comment
steps inside `affineBaseChange_pushforward_iso` (`AlgebraicGeometry/Cohomology/FlatBaseChange.lean`,
which has 2 documented sorries and no decls named for these steps). Per DAG integrity
rule 1, pinned TODO placeholders (consistent with the ~20 existing `AlgebraicGeometry.TODO.*`
placeholders in the project):
- `lem:base_change_map_affine_local` → `\lean{AlgebraicGeometry.TODO.base_change_map_affine_local}`
- `lem:pushforward_base_change_mate_cancelBaseChange` → `\lean{AlgebraicGeometry.TODO.pushforward_base_change_mate_cancelBaseChange}`

Both already carried complete `\uses{}` (statement + proof) and full Stacks citations
(`% SOURCE` / `% SOURCE QUOTE` / `\textit{Source:}`), and are consumed by
`lem:affine_base_change_pushforward` — so the only defect was the missing pin. No
citation lines were added/changed (existing prose is well-cited per the directive's
"do not rewrite" rule).

## Could not complete (genuine gaps / STRATEGY ITEM)

**The directive's premise is FALSE for four StructureSheafModuleK nodes** — their
`\lean{}` pins point to Lean declarations that have been DELETED, so they are NOT
"already proved sorry-free in Lean":

- `thm:Scheme_IsAffineHModuleHomFinite` → `AlgebraicGeometry.Scheme.IsAffineHModuleHomFinite`
- `thm:Scheme_module_finite_HModule_prime_zero_of_isAffineHModuleHomFinite` → `…module_finite_HModule'_zero_of_isAffineHModuleHomFinite`
- `thm:Scheme_module_finite_HModule_prime_of_affine` → `…module_finite_HModule'_of_affine`
- `thm:Scheme_module_finite_HModule_prime_of_affine_curve` → `…module_finite_HModule'_of_affine_curve`

Fixed-string grep across all `*.lean` finds **none** of these four declarations; the
only surviving trace is the iter-041 historical note at
`StructureSheafModuleK/Carriers.lean:28`, which records that the
**per-affine-open Hom-finiteness approach was deliberately abandoned** because on a
proper curve `Γ(U, O_C) = k[t]` is infinite-dimensional over k (e.g. the standard
`ℙ¹` cover). The live finiteness engine instead uses the **wholespace** carrier
`thm:Scheme_IsHModuleHomFinite` + `inst:Scheme_instIsHModuleHomFinite_toModuleKSheaf`,
which IS proved. These four blocks therefore describe a dead approach; their
`\lean{}` pins are stale and they still (wrongly) carry `\leanok`.

Decision taken (conservative, in-scope):
- I **wired their `\uses{}`** as the directive requested (internal coherence — the
  edges correctly transcribe what the prose claims: `_of_affine` case-splits to the
  H⁰ and H>0 consumers; `_of_affine_curve` specialises `_of_affine`; etc.).
- I **did NOT touch their `\lean{}` pins or `\leanok`** (changing a pin to TODO would
  flip them to phantom "unformalized obligations" and risk a prover being sent at a
  mathematically-misguided, deliberately-abandoned lemma; `\leanok` is the sync phase's).
- I added a short `% NOTE (dag-walker iter-270): …` on each of the four flagging the
  stale pin and pointing to the historical note.

**Recommendation for the dispatcher / review agent:** these four blocks are
candidates for **deletion** (they describe an abandoned, application-wrong approach and
are consumed by nothing outside their own internal cluster). If kept, the review
agent should either (a) `\mathlibok`-style retire them, or (b) repin to a TODO and
strip `\leanok` via sync — but only after confirming the project truly does not intend
to revive per-affine-open Hom-finiteness (it does not, per the Carriers.lean note).
This is the one honesty defect the wiring pass cannot fix without a strategy call.

## References consulted
- None fetched. Both `Cohomology_FlatBaseChange.tex` gap nodes already carry complete,
  verbatim Stacks citations (tag 02KH / Cohomology of Schemes "Affine base change",
  and tag 01I9 for the pullback companion); the directive's
  `references/stacks-coherent.md` and `references/stacks-varieties.md` were only to be
  consulted if a derived block LACKED a citation — none did.

## Notes for dispatcher
- **Zero broken `\uses` introduced**; the single project-wide `unknown_uses`
  (`thm:genus_zero_curve_iso_p1` → `cor:nonconstant_function_genus_zero`) pre-exists and
  is outside this cone/scope.
- The seed's literal cone is small (4 ancestors: `def:Scheme_kToSection`,
  `thm:Scheme_SheafGammaObj_linearEquiv_top`, `thm:finite_appTop_of_universallyClosed`
  [mathlibok], `thm:Scheme_module_finite_globalSections_of_isProper`). The broader
  finiteness chapter is now also internally wired per the directive's node list, even
  where those nodes are not literal ancestors of the seed (they form the consumer side:
  the seed feeds `instIsHModuleHomFinite_toModuleKSheaf`, `rdep=1`).
- `Cohomology_FlatBaseChange.tex` wiring was effectively already complete (rich `\uses`
  + citations); it needed only the two `\lean{}` pins.
- The four deleted-decl blocks above are the only strategy item; everything else is
  honestly wired and finite-effort.
