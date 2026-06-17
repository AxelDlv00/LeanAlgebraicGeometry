# strategy-critic directive — iter-038

You are a fresh-context critic of the GLOBAL strategy. Read ONLY the files named below. Do NOT read any
`.archon/iter/**` sidecars, `task_pending.md`, `task_done.md`, `task_results/**`, review reports, or session
journals — your value is seeing the strategy as a fresh mathematician, free of project momentum.

## Read these (and only these)
- `.archon/STRATEGY.md` (verbatim — the strategy to critique).
- `references/summary.md` (the reference index backing the project).
- For blueprint context, you may open the chapter files' opening lines only for the topic of each chapter;
  do not deep-read proofs.

## Project goal (one paragraph)
Close the `sorry`-bearing nodes of the **Čech-independent leg** of Kleiman's `thm:fga_pic_representability`
cone (FGA "The Picard scheme", §4): (FBC) the i=0 flat-base-change map `g^* f_* F ⟶ f'_* g'^* F` is an iso
(Stacks 02KH); (GF) generic flatness (Nitsure §4); (QUOT) the Quot/Grassmannian definitions + Hilbert
polynomial + `grassmannian_representable`. End-state: zero project `sorry` in the closure, kernel-only axioms,
names/labels matching the parent so the work merges back.

## Blueprint chapters (title — one-line topic)
- Cohomology_FlatBaseChange — affine i=0 flat base change; the `gstar_transpose` mate coherence (FBC).
- Cohomology_RegroupHelper — `regroupEquiv` tensor-tower iso (DONE, FBC module core).
- Picard_FlatteningStratification — generic flatness algebraic core + geometric wrapper (GF).
- Picard_GrassmannianCells — Grassmannian charts/cocycle/glue/separated/proper-via-valuative (QUOT-repr).
- Picard_QuotScheme — Quot functor, Hilbert polynomial, qcoh≃Mod affine descent keystone "gap1" (QUOT).
- Picard_RelativeSpec — relative Spec representability infrastructure.

## What I most need your fresh judgment on this iter
1. **FBC route (Q2 in STRATEGY).** The `gstar_transpose` coherence has been STUCK 5+ iters. STRATEGY now
   frames iter-038 as a SHARPENED mathlib-analogist consult to decide continue-the-conjugate-re-encoding vs.
   pivot-the-affine-iso-proof. Is this the right structural response, or is the planner still sunk-cost on the
   conjugate vehicle? Is there a structurally simpler decomposition of the affine i=0 iso that the strategy is
   missing (e.g. proving it at the underlying-module level via the already-DONE `regroupEquiv`, never forming
   the categorical mate)? Challenge if the strategy is over-investing in the mate calculus.
2. **QUOT gap1.** Bridges (I)+(II) are DONE; the remaining wall is the semilinearity of `gammaPullbackImageIso`
   over an open-immersion structure-sheaf ring iso. Is this decomposition sound, or is there a cheaper path to
   the qcoh-affine descent keystone that avoids the semilinearity sub-build?
3. **General soundness.** Any phase whose iters-left/LOC estimate looks structurally wrong, any route with a
   missing prerequisite, any case-split that the references do not support.

Report SOUND / CHALLENGE / REJECT per route with concrete, reference-anchored reasoning. If you CHALLENGE,
name the specific alternative you would take.
