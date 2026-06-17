# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
fbc-route-pivot

## Iteration
038

## Structural problem
Prove the affine i=0 flat-base-change comparison `g^* f_* F ⟶ f'_* g'^* F` (Stacks 02KH part 2) is
an isomorphism for `Spec`-affine schemes. `pushforwardBaseChangeMap` is **defined** as an adjoint
mate; iso-ness of the abstract algebraic conjugate is free; the open obligation is the **coherence**
identifying the geometric mate's value with that conjugate, bottoming out at
`base_change_mate_gstar_transpose` (sorry :2167) and beneath it
`base_change_mate_fstar_reindex_legs_conj` (sorry :1700). Question: KEEP the conjugate re-encode, or
PIVOT to a different route?

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `CompositionIso.lean`/`Mates.lean` conjugate-component calculus (KEEP) | composite-adjunction category theory | medium | ANALOGUE_FOUND |
| module-level `cancelBaseChange`/`regroupEquiv`, "never form the mate" (PIVOT a) | commutative algebra | — | NO_USEFUL_ANALOGUE |
| Mathlib/Lean geometric pushforward base-change package (PIVOT b/c) | algebraic geometry | — | NO_USEFUL_ANALOGUE |

## Top suggestion

**KEEP — execute the proof-free re-cut to completion; no route bypasses the mate coherence.**

Decisive facts established this iter:

1. **The cascade Q1 feared is already neutralized.** The project implemented exactly the contained
   idiom Q1 asks for: `base_change_mate_codomain_read_legs_param` (:1427) abstracts the pullback
   factor; `conjPullbackFactor` (:1489) = `Adjunction.leftAdjointCompIso` (signature hover-confirmed);
   `base_change_mate_codomain_read_legs_conj` (:1563) is the proof-free conjugate read;
   `..._conj_eq` (:1594) bridges it to the concrete read. `codomain_read_legs` is **unchanged**, and
   `gstar_transpose` consumes the *separate* no-legs `base_change_mate_codomain_read`, so it is fully
   insulated. The only residual sorry in the chain (`_legs_conj`, :1700) is the genuine conjugate-side
   coherence **proof**, not a re-typing cascade. There is nothing further to re-encode.

2. **The coherence is irreducible (PIVOT a blocked).** `pushforwardBaseChangeMap` is the target and
   is *defined* as `homEquiv.symm(inner) = g^*(inner) ≫ counit`; every unwinding returns the mate form
   (failed-approach #1, dead-end :2097). Iso-ness cannot be obtained by "whiskering an iso" — the
   `(g^*⊣g_*)` counit is not iso even for affine `Spec ψ`, and a transpose of an iso is not an iso. In
   the affine case iso-ness genuinely requires identifying the value (= `cancelBaseChange⁻¹`), which
   *is* the coherence. The variable-legs `subst` already performs the transport-to-nice-apex a
   module-level route would attempt, so there is no saving.

3. **No geometric base-change package exists (PIVOT b/c).** `lean_leansearch` returns only
   module-level results (`Module.Flat.isBaseChange`, `RingHom.Flat.isStableUnderBaseChange`);
   `SheafOfModules.pushforward` search is empty; the only Beck–Chevalley carrier
   (`iterated_mateEquiv_conjugateEquiv`) needs all four functors left-adjoint, which the *geometric*
   square fails (pushforward is right adjoint). No Lean formalization of Stacks 02KH to port.

Concrete lowest-risk ordering for iter-039:
- Build conj-2b `base_change_mate_reindex_conj_pullbackLeg` standalone
  (`Adjunction.conjugateEquiv_leftAdjointCompIso_inv` + `Scheme.Modules.conjugateEquiv_pullbackComp_inv`,
  both confirmed present).
- Build conj-2d `base_change_mate_reindex_conj_crossLayer` standalone (Seam-1 template:
  `unit_conjugateEquiv_symm` raised by `conjugateEquiv_comp`).
- Then the single-`conjugateEquiv`-component reframing + `.injective` close of `_legs_conj`
  (conj-2c already proved at :1626). Once `_legs` is axiom-clean, `gstar_transpose` may **cite**
  `base_change_mate_fstar_reindex` for step (a) (its inline-reproof comment at :2089 is conditioned
  only on `_legs` being sorry-backed); step (b) is proved and `huce` assembled.

## Strategic caveats (do not skip)

- **The component-reframing in the final step is the real risk**, not the route choice. If it resists
  one more focused iter after conj-2b/2d land, the tripwire response is to accept a documented `sorry`
  or rescope the deliverable — **not** to switch routes, because no alternative route exists.
- **`gstar_transpose` is necessary but not sufficient for `affineBaseChange_pushforward_iso`.** That
  theorem (:2317) carries a **second, independent** sorry at :2348 — the affine *reduction* (arbitrary
  cartesian square → affine charts; section-level → sheaf-level), documented in-file as
  "multi-hundred-LOC, Mathlib-absent" and untouched. It is comparable in size to the coherence grind.
  Closing the section coherence is **not** finishing affine base change. If iteration budget is the
  binding constraint, dispatch a separate api-alignment query on whether the :2348
  restriction-compatibility of `pushforwardBaseChangeMap` along affine opens has a cheaper
  Mathlib-backed path — that is the higher-leverage unknown.

## Discarded
- `iterated_mateEquiv_conjugateEquiv` as an iso certificate for the *geometric* square: inapplicable
  (geometric square is not four-left-adjoints; that is why flatness/affineness is needed at all).
- "Transport to the `Spec(A⊗_R R')` apex before analyzing the mate": already embodied by the
  variable-legs `subst`; offers no new saving and still leaves the counit coherence.

## Persistent file
- `analogies/fbc-route-pivot.md` — full analysis captured for future iters.

Overall verdict: KEEP the conjugate re-encode (the only route to an irreducible coherence; cascade
already contained), but recognize the section coherence is one of two comparably-large gaps in the
affine theorem.
</content>
