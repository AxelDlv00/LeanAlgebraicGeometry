# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
fbc-diamond

## Iteration
029

## Structural problem
Rewrite ONE factor `F.map uₖ` (provably `= 𝟙` or `= g`) inside a long composite of `Functor.map`
images `F.map u₁ ≫ … ≫ F.map uₙ` over `X.Modules`, WITHOUT a head-symbol `rw`/`simp`/`erw`, when the
implicit (co)domain object on `uₖ` is in the **nested-`obj`** form `G.obj (H.obj M)` (from
`rw [Functor.map_comp]`) while the collapse lemma fixes the **composed-`⋙`** form `(H ⋙ G).obj M`. The
two are defeq-not-syntactic, so keyed `rw`/`simp` cannot abstract the motive and `erw`'s defeq search
blows the `whnf` budget on the huge concrete leg term. Same diamond recurs at each of the four atom
cancellations.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| In-project templates (`pullbackPushforward_unit_comp`, `gammaDistribute`, `eCancel_pushforwardComp`) | alg geom / `X.Modules` (same) | low | ANALOGUE_FOUND |
| `Mathlib/CategoryTheory/Adjunction/Mates.lean` (`unit_conjugateEquiv`, `conjugateEquiv`) | category theory | low–medium | ANALOGUE_FOUND |
| `Mathlib/CategoryTheory/SimplicialObject/Basic.lean` (`δ_comp_δ'`, `δ_comp_δ_self'`) | algebraic topology | medium | ANALOGUE_FOUND |
| `Mathlib/CategoryTheory/Monoidal/Category.lean` (`whiskerLeft`/`whiskerRight`, `reassoc`, `coherence`) | monoidal cat theory | framing only | PARTIAL_ANALOGUE |

## Does the GR recipe port?

**Yes — and the port already exists in this file, over the exact `X.Modules`/`Functor.map` setting.**
The GR kernel is: build the collapse on a FRESH clean term (`have`), lift it into the composite with
`congrArg`, close with `exact …` so the defeq check (not `rw`/`simp`/`erw`) absorbs the diamond +
associativity. Three shipped, compiling FBC proofs are exactly this:

- `FlatBaseChange.lean:1144` `pullbackPushforward_unit_comp`: `have h := unit_conjugateEquiv …; rw […] at h;
  rw [← Category.assoc]; exact h` — the closing `exact h` bridges the `X.Modules` `CategoryStruct.comp`
  diamond, identical role to GR's `exact congrArg (_ ≫ ·) hXY`.
- `FlatBaseChange.lean:1304` `..._gammaDistribute`: `exact (F.map_comp _ _).trans (congrArg (· ≫ F.map _)
  ((F.map_comp _ _).trans (congrArg (F.map _ ≫ ·) (F.map_comp _ _))))` — the canonical term-mode
  `Functor.map_comp` distributor and the template for one-sided `congrArg (· ≫ _)`/`(_ ≫ ·)` factor surgery.
- `FlatBaseChange.lean:1534` `base_change_mate_inner_eCancel_pushforwardComp`: `(Γ.congr_map ((Spec φ)_*.map_id _)).trans
  (Γ.map_id _)` — uses `CategoryTheory.Functor.congr_map` (`Mathlib/CategoryTheory/Functor/Basic.lean`,
  confirmed via hover) to push a morphism equation through `Γ.map`, and is ALREADY in the goal's
  `Γ ∘ (Spec φ)_*` form (not the bare `gammaMap_pushforwardComp_hom_eq_id` form that the failed `hpfc` uses).

The canonical Mathlib mechanism for single-factor surgery inside a functor-image composite past a
coherence/instance diamond is therefore: `congrArg (· ≫ _)` / `congrArg (_ ≫ ·)` / `Functor.congr_map F h`,
chained with `.trans`, closed with `exact`; `eqToHom`/`eqToHom_map` for genuine object-equality
repackaging (cf. `gammaMap_pushforwardCongr_hom`'s `= eqToHom (by rw [hfg])`). The defeq (obj-nested ↔
⋙-composed) bridge happens at the `exact`/`.trans` seam — the move `rw`/`simp`/`erw` structurally cannot make.

## Top suggestion

Port the three in-file templates; do not introduce new infrastructure. At the `sorry`
(`FlatBaseChange.lean:1445`):

1. **Distribute** `(Spec φ)_*` then `Γ` over the `unitExpand` four-factor via the term-mode lemma
   `base_change_mate_fstar_reindex_legs_gammaDistribute` (NOT `rw`/`simp [Functor.map_comp]` — that no-ops on
   the diamond, as the in-file comment and failed approaches confirm).
2. **Collapse the surviving `pushforwardComp(g',Spec φ).hom` Γ-factor** with the shipped
   `base_change_mate_inner_eCancel_pushforwardComp e.hom (Spec.map inclA) φ (tilde M)` (already in the goal's
   `Γ ∘ (Spec φ)_*` form — abandon `hpfc`/bare `gammaMap_pushforwardComp_hom_eq_id`), spliced with
   `congrArg (· ≫ _)` / `congrArg (_ ≫ ·)` (underscore neighbours), `.trans`-chained, then `Category.id_comp`/
   `comp_id` to drop the `𝟙`.
3. **Splice the three eCancel atoms** (`_eUnit` via `IsIso`+`asIso`, `_pushforwardComp`, `_pullbackComp`) the
   same way against the UNFOLDED `base_change_mate_codomain_read_legs`.
4. **Close with `exact … .trans …`** onto `base_change_mate_inner_value`; the final `exact` absorbs the
   residual obj-form/associativity defeq (the GR `exact congrArg` role).

First Mathlib file to read for the abstract framing, if a cleaner whole-composite reformulation is wanted
over factor-by-factor splicing: `Mathlib/CategoryTheory/Adjunction/Mates.lean` (`unit_conjugateEquiv` is
already imported and used at `FlatBaseChange.lean:1154`). First project file to touch: `FlatBaseChange.lean`
at the `sorry`, line 1445.

Caveat to the prover: validate incrementally (one factor per `.trans` link, checking the goal between
splices). The full composite is large; the value of term mode is precisely that each `congrArg` link is
checked independently and the diamond is deferred to the final `exact`.

## Discarded
- Monoidal `coherence`/`monoidal` tactic: the diamond is on `Functor.map` domains, not associators, so the
  tactic does not apply (kept only for the `whiskerLeft`/`whiskerRight` = one-sided-congruence framing).
- Re-trying any keyed `rw`/`simp`/`erw [gammaMap_pushforwardComp_hom_eq_id]`: matches the directive's failed
  approaches (motive-abstraction failure / `whnf` timeout) — explicitly NOT recommended.

## Persistent file
- `analogies/fbc-functorimage-diamond.md` — analogue list + ported recipe captured for future iters.

Overall verdict: the GR `exact congrArg`/defeq-inside-`exact` recipe ports directly — the file already
contains three compiling instances of it over `X.Modules`; the surviving telescoping is a splice of shipped
lemmas via `congrArg`/`Functor.congr_map`/`.trans`/`exact`, never a keyed `rw`/`simp`/`erw`.
