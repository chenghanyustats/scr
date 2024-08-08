1. What are the rest of the variables standing for? 

ID = participant ID
Run = variant of the task that the participant completed
Condition = condition within that task (same for all runs)
Trial = trial number for that condition
CS.StimTime = this reflects the time at which the physiological response occurred in the task (反應開始的時間)
CS.SCL = this reflects the baseline level of arousal that the participant was experiencing just before they had a physiological response (還沒reponse之前的scr值)
CS.Latency = this reflects the time between a stimulus (that was shown to the participant) and their physiological response (開始刺激後，過多久開始有反應)
CS.SCRAmplitude = this reflects the height of the physiological response (how big) (response 的反應最大值？)
CS.SCRRiseTime = this reflects how long it took for the participant’s physiological response to reach its maximum (多久response爬到最大)
CS.SCRSize = similar to area under the curve (AUC), or the overall size of the physiological response (response 總大小)
CS.SCROnset = this reflects the time during the task that the physiological response occurred (reponse 維持多久)
 
2. There are lots of #NULL! or missing values. Why some have values and some do not? Any meanings? Yes, you can expect lots of missing. That’s because not every participant will have a physiological response to every trial but every participant will have at least one response. The amount of missing is normal but does make traditional analyses tricky – hence, I’m interested in unique modeling methods to account for missing in some fashion.
 
3. The data do not have demographics such as gender. Correct – I have demographic data in another dataset. If you think you’d like to include some demographics in your modeling, then I can send you over the relevant ones.
 
4. When doing analysis, we don’t consider Learning but just Run1 to Run3. Yes, for now I would only like to consider Learning.
 
5. I’ll first get to know the data by some data visualization. Are any variables or relationships deserved to be examined? Trial effects are particularly interesting to me – changes in the responses over trial numbers. But open to other ways to visualize the data.
 
Are there any graduate students working with you on this or other SCR projects? I could have one student working on this during the summer. If your student wants to learn R and/or Bayesian modeling, I’m happy to get them involved. As discussed, our first goal is to write a paper by performing the Bayesian equivalent of the models used in your 2022 Psychophysiology paper. Yes – I have a graduate student, Kaley, who is interested in helping. I’ve cc’d her here.



- meanings of "Fear" "Fear.Safety" "Reward" "Reward.Safety" "Safety" corresponding to the paper. Safety means neutral?

- Cue assignment was counter-balanced across participants, such that four versions of the task were used, shuffling cue assignment. In this way, trial order was randomized across participants to balance stimulus sequence and avoid habituation or sensitization effects.

Does the dataset present such assignment?

101	Run1	Fear
101	Run1	Fear
101	Run1	Fear
101	Run1	Fear
101	Run1	Fear
101	Run1	Fear
101	Run1	Fear
101	Run1	Fear
101	Run1	Fear.Safety
101	Run1	Fear.Safety
101	Run1	Fear.Safety
101	Run1	Fear.Safety
101	Run1	Fear.Safety
101	Run1	Fear.Safety
101	Run1	Fear.Safety
101	Run1	Fear.Safety
101	Run1	Reward
101	Run1	Reward
101	Run1	Reward
101	Run1	Reward
101	Run1	Reward
101	Run1	Reward
101	Run1	Reward
101	Run1	Reward
101	Run1	Reward.Safety
101	Run1	Reward.Safety
101	Run1	Reward.Safety
101	Run1	Reward.Safety
101	Run1	Reward.Safety
101	Run1	Reward.Safety
101	Run1	Reward.Safety
101	Run1	Reward.Safety
101	Run1	Safety
101	Run1	Safety
101	Run1	Safety
101	Run1	Safety
101	Run1	Safety
101	Run1	Safety
101	Run1	Safety
101	Run1	Safety

- unit of CS variables?

- no Anxiety ratings

- no Likeability ratings

- State anxiety: Using Bayesian t test

- Likeability ratings: Bayesian hierarchical model

- normalize SCR

- What does Extincti mean?
Extincti = this is a Run (each participant gets 4 runs). It stands for “extinction” and is actually the last run participants experience. Only ~ ½ our participants received this run.


